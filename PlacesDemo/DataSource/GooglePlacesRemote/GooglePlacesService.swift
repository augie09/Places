//
//  GooglePlacesService.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//

import Foundation
import Combine

struct GooglePlacesService: GooglePlacesProtocol {
        
    private let apiKey: String
    private let urlProvider : GooglePlacesUrlProviderProtocol
    
    //FIXME:- these should be injected
    private let urlSession = URLSession.shared
    private let decoder = JSONDecoder()
    
    init(apiKey: String,
         urlProvider: GooglePlacesUrlProviderProtocol){
        self.apiKey = apiKey
        self.urlProvider = urlProvider
    }

    func nearbySearch(type: GooglePlacesType,
                      latitude: Double,
                      longitude: Double,
                      radius: Int,
                      keyword: String?) -> AnyPublisher<[GooglePlace], Error> {
        
        print("nearbySearch starting")
        
        // Construct the API URL
        guard let url: URL = urlProvider.nearbySearchQuery(type:type,
                                                  latitude: latitude,
                                                  longitude: longitude,
                                                  radius: radius,
                                                  keyword: keyword,
                                                  apiKey: apiKey,
                                                  responseType: .json) else {
            print("nearbySearch failed, badURL")
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return urlSession.dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                    print("nearbySearch failed, badServerResponse")
                    throw URLError(.badServerResponse)
                    }
                print("nearbySearch success: 200 response")
                return element.data
                }
            .decode(type: GooglePlacesResponse.self, decoder: JSONDecoder())
            .print("nearbySearch publisher")
            .map(\.results)
            .eraseToAnyPublisher()
    }
    
    /// asks the remote datasource for a url to the photo reference
    /// - Parameter from: Place photo reference value
    func photoUrl(from reference: String) -> URL? {
        return urlProvider.photoUrl(from: reference, apiKey: apiKey)
    }
}
