//
//  Place.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//

import Foundation
import CoreLocation

struct Place {
    
    let id: String
    let name: String
    let rating: Double?
    let totalRatings: Int?
    let priceLevel: Int?
    let favorite: Bool
    let latitude: Double
    let longitude: Double
    let photo: URL?

}
