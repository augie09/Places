//
//  SearchViewModelProtocol.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//

import Foundation
import Combine

protocol SearchViewModelProtocol {
    
    init(repo: PlacesRepositoryProtocol)
    
    // Places DataSource and Pubhlisher
    var placesPublisher: Published<[Place]>.Publisher {get}
    var places: [Place] {get}
    
    // Subject for ViewControllers to send search text changes to
    var textSubject: CurrentValueSubject<String, Never> {get set}

    // other UI data
    var searchPlaceHolder : String {get}
    
    // favorite button
    func favoritePressed(for indexPath: IndexPath)
}
