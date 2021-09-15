//
//  FavoritePlacesProtocol.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//

import Foundation

protocol FavoritePlacesProtocol {
    
    /// Save a place as a favorite
    /// - Parameter place: Place
    func favorite(_ place: Place) -> Place
    
    /// Remove a place from favorites
    /// - Parameter place: Place
    func unfavorite(_ place: Place) -> Place
    
    /// Determine if a place is a favorite
    /// - Parameter id: Place Id
    func isFavorite(_ id: String) -> Bool

}
