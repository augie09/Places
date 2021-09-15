//
//  SearchViewModel.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//

import Foundation
import Combine

class SearchViewModel: SearchViewModelProtocol, ObservableObject, Identifiable {
    
    // Dependencies
    private let placesRepository : PlacesRepositoryProtocol
    private let locationService : LocationUtilityProtocol
     
    // Combine Stuff
    @Published var places: [Place] = []
    var placesPublisher: Published<[Place]>.Publisher { $places }
    var textSubject: CurrentValueSubject<String, Never> = CurrentValueSubject.init("")
    private var disposables = Set<AnyCancellable>()
    
    // currently we only need to get location once, even though it is setup for event streaming
    var firstKnownLocation: CurrentValueSubject<(latitude: Double, longitude: Double)?, Never> = CurrentValueSubject.init(nil)
    let radius: Int = 1500

    // Static data for UI
    var searchPlaceHolder : String { return "Search for a restaurant"}  //FIXME:- move to a localized string file
    
    //MARK: INIT
    required init(repo: PlacesRepositoryProtocol, locationService: LocationUtilityProtocol){
        self.placesRepository = repo
        self.locationService = locationService
        
        // Observe SearchBar text input changes
        self.textSubject
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.global())
            .sink { (_) in
                //
            } receiveValue: { [self] (searchField) in
                print("textSubject")
                fetchPlaces(with: searchField)
            }.store(in: &disposables)
        
        // Observe Location changes
        self.locationService.locationTuple
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.global())
            .sink { (_) in
                //
            } receiveValue: { [self] (location) in
                
                // this apps requirements is only interested in initial user location, not updating as user moves
                if firstKnownLocation.value == nil, let location = location {
                    firstKnownLocation.send(location)
                    fetchPlaces(with: textSubject.value)
                }
            }.store(in: &disposables)
    }
    
    //MARK: PROTOCOL METHODS
    func fetchPlaces(with searchText: String?){
        
        guard let location = firstKnownLocation.value else {
            print("location not known")
            return
        }
        
        placesRepository.nearbySearch(latitude: location.latitude,
                                      longitude: location.longitude,
                                      radius: radius,
                                      keyword: searchText ?? nil)
            .receive(on: DispatchQueue.main)
            
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure:
                    self.places = []
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] places in
                guard let self = self else { return }
                
                self.places = places
                places.forEach { p in
                    print("Place: \(p.name): isFavorite:\(p.favorite)")
                }
            })
            
            .store(in: &disposables)
        
    }
    
    func viewDidLoad(){
        if !locationService.hasRequested(){
            locationService.requestPermission()
        }
    }
    
    //MARK: FAVORITES
    // favorite button
    func favoritePressed(for indexPath: IndexPath){
        print("SearchViewModel: favoritePressed")
        let place = places[indexPath.row]
        if place.favorite {
            places[indexPath.row] = unfavorite(place)
        }
        else {
            places[indexPath.row] = favorite(place)
        }
    }
    
    /// Favorite a Place
    /// - Parameter place: Place
    /// - Returns: The Place after datalayer processed the favorite request
    private func favorite(_ place: Place) -> Place{
        return placesRepository.favorite(place)
     }
    
    /// Unfavorite a Place
    /// - Parameter place: Place
    /// - Returns: The Place after datalayer processed the unfavorite request
    private func unfavorite(_ place: Place) -> Place{
        return placesRepository.unfavorite(place)
    }
    
    //MARK: PHOTOS
    /// asks the remote datasource for a url to the photo reference
    /// - Parameter from: Place photo reference value
    func photoUrl(from reference: String) -> URL? {
        return placesRepository.photoUrl(from: reference)
    }
}
