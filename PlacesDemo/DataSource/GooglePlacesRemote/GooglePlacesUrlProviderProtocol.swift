//
//  GooglePlacesUrlProviderProtocol.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//

import Foundation

protocol GooglePlacesUrlProviderProtocol {

    /// constructs an array of query items for a nearby search
    /// - Parameters:
    ///   - latitude: latitude, Double
    ///   - longitude: longitude, Double
    ///   - radius: search radius
    ///   - keyword: optional keyword, string
    ///   - apiKey: apiKey
    func nearbySearchQuery(type: GooglePlacesType,
                           latitude: Double,
                           longitude: Double,
                           radius: Int,
                           keyword: String?,
                           apiKey: String,
                           responseType: GooglePlacesUrlsResponseType?) -> URL?
}
