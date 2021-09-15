//
//  PlacesRepositoryProtocol.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//
//  This repository is responsible for place models
//  including fetching, favoriting and photo urls

import Foundation
import Combine

protocol PlacesRepositoryProtocol {
    
    init(remote: GooglePlacesProtocol,
         local: FavoritePlacesProtocol)
    
    /// Search remote datasource for places
    /// - Parameters:
    ///   - latitude: center location latitude
    ///   - longitude: center location longitude
    ///   - radius: radius of search, in meters
    ///   - keyword: optional query search string
    func nearbySearch(latitude: Double,
                      longitude: Double,
                      radius: Int,
                      keyword: String?) -> AnyPublisher<[Place], Error>
    
    /// Save a place as a favorite
    /// - Parameter place: Place
    func favorite(_ place: Place) -> Place
    
    /// Remove a place from favorites
    /// - Parameter place: Place
    func unfavorite(_ place: Place) -> Place
    
    /// asks the remote datasource for a url to the photo reference
    /// - Parameter from: Place photo reference value
    func photoUrl(from reference: String) -> URL?
}
