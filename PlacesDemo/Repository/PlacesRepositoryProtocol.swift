//
//  PlacesRepositoryProtocol.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//

import Foundation
import Combine

protocol PlacesRepositoryProtocol {
    
    init(remote: GooglePlacesProtocol,
         local: FavoritePlacesProtocol)
    
    func nearbySearch(latitude: Double,
                      longitude: Double,
                      keyword: String?) -> AnyPublisher<[Place], Error>
    
    func favorite(_ place: Place) -> Place
    
    func unfavorite(_ place: Place) -> Place
    
    /// asks the remote datasource for a url to the photo reference
    /// - Parameter from: Place photo reference value
    func photoUrl(from reference: String) -> URL?
}
