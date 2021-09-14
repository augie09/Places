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
    let photo: String?

    func priceLevelSigns() -> String {
        guard let priceLevel = priceLevel, priceLevel > 0 else {
            return ""
        }
        return String.init(repeating: "$", count: priceLevel)
    }
}
