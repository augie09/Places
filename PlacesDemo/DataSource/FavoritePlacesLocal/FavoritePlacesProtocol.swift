//
//  FavoritePlacesProtocol.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//

import Foundation

protocol FavoritePlacesProtocol {
    
    func favorite(_ place: Place) -> Place
    
    func unfavorite(_ place: Place) -> Place
    
    func isFavorite(_ id: String) -> Bool

}
