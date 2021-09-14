//
//  GooglePlace.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//
//  This is a model of a Google Places api response object for a single Google Place

import Foundation

struct GooglePlace : Codable {
    let place_id: String
    let rating: Double?
    let user_ratings_total: Int?
    let name: String
    let price_level: Int?
    private let photos: [GooglePlacesPhotoReference]?
    private let geometry: GooglePlacesGeometry
    
    /// Coordinates of this place
    /// - Returns: (latitude, longitude)
    func location() -> (Double, Double){
        return (geometry.location.lat, geometry.location.lng)
    }
    
    func photoReference() -> String? {
        guard let photo = photos?.first else { return nil}
        return photo.photo_reference
    }
}

struct GooglePlacesPhotoReference : Codable {
    let photo_reference: String
}

struct GooglePlacesLocation : Codable {
    let lat: Double
    let lng: Double
}

struct GooglePlacesGeometry : Codable {
    let location: GooglePlacesLocation
}
