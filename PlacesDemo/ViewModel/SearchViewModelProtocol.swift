//
//  SearchViewModelProtocol.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//

import Foundation
import Combine

protocol SearchViewModelProtocol {
    
    var placesPublisher: Published<[Place]>.Publisher {get}
    var places: [Place] {get}
    var textSubject: CurrentValueSubject<String, Never> {get set}
    
    init(repo: PlacesRepositoryProtocol)
    
    func fetchPlaces(with searchText: String?)
}
