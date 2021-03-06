//
//  SearchViewModelProtocol.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//

import Foundation
import Combine

protocol SearchViewModelProtocol {
    
    init(repo: PlacesRepositoryProtocol, locationService: LocationUtilityProtocol)
    
    // Places DataSource and Pubhlisher
    var placesPublisher: Published<[Place]>.Publisher {get}
    var places: [Place] {get}
    
    /// asks the remote datasource for a url to the photo reference
    /// - Parameter from: Place photo reference value
    func photoUrl(from: String) -> URL?
    
    // Location Subject - currently updated only once with initial user location
    var firstKnownLocation: CurrentValueSubject<(latitude: Double, longitude: Double)?, Never>{get set}
    var radius: Int { get }
    
    // Subject for ViewControllers to send search text changes to
    var textSubject: CurrentValueSubject<String, Never> {get set}

    // favorite button
    func favoritePressed(for indexPath: IndexPath)
    
    // this could be a publisher
    func viewDidLoad()

    
    // other UI data
    var searchPlaceHolder : String {get}

}
