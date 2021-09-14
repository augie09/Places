//
//  SearchViewModel.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//

import Foundation
import Combine

class SearchViewModel: SearchViewModelProtocol, ObservableObject, Identifiable {
    
    private let placesRepository : PlacesRepositoryProtocol
     
    @Published var places: [Place] = []
    var placesPublisher: Published<[Place]>.Publisher { $places }
    
    var textSubject: CurrentValueSubject<String, Never> = CurrentValueSubject.init("")
    
    private var disposables = Set<AnyCancellable>()
    
    private var latitude : Double = -33.8670522  //FIXME:- get from CoreLocation
    private var longitude: Double = 151.1957362
    
    var searchPlaceHolder : String { return "Search for a restaurant"}  //FIXME:- move to a localized string file
    
    //MARK: INIT
    required init(repo: PlacesRepositoryProtocol){
        self.placesRepository = repo
        
        self.textSubject
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.global())
            .sink { (_) in
                //
            } receiveValue: { [self] (searchField) in
                print("textSubject")
                fetchPlaces(with: searchField)
            }.store(in: &disposables)
    }
    
    //MARK: PROTOCOL METHODS
    func fetchPlaces(with searchText: String?){
        
        placesRepository.nearbySearch(latitude: latitude,
                                      longitude: longitude,
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
    
    func favoriteItem(at index: IndexPath){
        let newPlace = placesRepository.favorite(places[index.row])
        places[index.row] = newPlace
    }
    
    func unfavoriteItem(at index: IndexPath){
        let newPlace = placesRepository.unfavorite(places[index.row])
        places[index.row] = newPlace
    }
}
