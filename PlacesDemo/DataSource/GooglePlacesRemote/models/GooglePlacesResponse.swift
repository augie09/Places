//
//  GooglePlacesResponse.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//
//  This is a model of a Google Places api response object for a search

import Foundation

struct GooglePlacesResponse  : Codable {
    
    let results : [GooglePlace]
    let status: String
}
