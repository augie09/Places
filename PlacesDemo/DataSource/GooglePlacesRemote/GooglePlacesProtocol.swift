//
//  GooglePlacesProtocol.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//
//

// GooglePlacesProtocol represents the highest level interface with the google places remote service

import Foundation
import Combine

protocol GooglePlacesProtocol {
    
    /// Initialize the GooglePlaces Service
    /// - Parameter apiKey: Google Places API from developers.google.com
    /// - Parameter urlProvider: GooglePlacesUrlProviderProtocol for URL endpoints
    init(apiKey: String,
         urlProvider: GooglePlacesUrlProviderProtocol)
    
    /// Perform a nearby search on google services api
    /// - Parameters:
    ///   - type: GooglePlacesType
    ///   - latitude: required, latitude for the search
    ///   - longitude: required, longitude for the search
    ///   - radius:  radius to search within
    ///   - keyword: optional, search text to use
    func nearbySearch(type: GooglePlacesType,
                      latitude: Double,
                      longitude: Double,
                      radius: Int,
                      keyword: String?) -> AnyPublisher<[GooglePlace], Error>
    
    /// asks the remote datasource for a url to the photo reference
    /// - Parameter from: Place photo reference value
    func photoUrl(from reference: String) -> URL?
}

/// Google defined place types to be used when filtering - subset
/// Extensive list:  https://developers.google.com/maps/documentation/places/web-service/supported_types
enum GooglePlacesType : String {
    case restaurant
    case campground
    case bakery
    case lodging
    case bar
    case bicycle_store
    case park
    case bus_station
    case parking
    case post_office
    case convenience_store
    case laundry
    case doctor
}
