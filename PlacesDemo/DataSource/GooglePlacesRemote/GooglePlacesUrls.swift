//
//  GooglePlacesUrls.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//

import Foundation

struct GooglePlacesUrls: GooglePlacesUrlProviderProtocol {
    
    // URL Endpoint construction components
    let scheme = "https"
    let host = "maps.googleapis.com"
    let nearbySearchPath = "/maps/api/place/nearbysearch"
   
    func nearbySearchQuery(type: GooglePlacesType,
                           latitude: Double,
                           longitude: Double,
                           radius: Int,
                           keyword: String?,
                           apiKey: String,
                           responseType: GooglePlacesUrlsResponseType?) -> URL? {
        var components = nearbySearchComponens(responseType: responseType)

        components.queryItems = nearbySearchQuery(type: type,
                                                  latitude: latitude,
                                                  longitude: longitude,
                                                  radius: radius,
                                                  keyword: keyword,
                                                  apiKey: apiKey)
        
        print("nearbySearchURL: \(components.url)")
        
        return components.url
    }
    
    private func nearbySearchComponens(responseType: GooglePlacesUrlsResponseType?) -> URLComponents {

        let responseType : GooglePlacesUrlsResponseType = responseType ?? .json
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = nearbySearchPath + "/" + responseType.rawValue
        
        return urlComponents
    }
 
    private func nearbySearchQuery(type: GooglePlacesType,
                                   latitude: Double,
                                   longitude: Double,
                                   radius: Int,
                                   keyword: String?,
                                   apiKey: String) -> [URLQueryItem]{
        var queryItems = [URLQueryItem]()
        queryItems.append(contentsOf: [
            query(name: .location, value: "\(latitude),\(longitude)"),
            query(name: .apiKey, value: apiKey),
            query(name: .type, value: type.rawValue),
            query(name: .radius, value: "\(radius)")
        ])

        if let keyword = keyword {
            queryItems.append( query(name: .keyword, value: keyword) )
        }
        
        return queryItems
    }
    
    private func query(name: GooglePlacesQueryName, value: String) -> URLQueryItem {
        return URLQueryItem(name: name.rawValue, value:value)
    }
}

/// Supported output content types from google api
enum GooglePlacesUrlsResponseType : String {
    case json
    case xml
}

enum GooglePlacesQueryName : String {
    case location
    case type
    case radius
    case keyword
    case apiKey = "key"
}
