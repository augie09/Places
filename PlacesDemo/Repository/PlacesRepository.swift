//
//  PlacesRepository.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//

import Foundation
import Combine

struct PlacesRepository : PlacesRepositoryProtocol {
    
    private let googlePlaces: GooglePlacesProtocol
    private let favoritePlaces: FavoritePlacesProtocol
    
    //FIXME:- these should be moved to a filter component
    private let searchType: GooglePlacesType = .restaurant
    private let radius: Int = 1500
    
    init(remote: GooglePlacesProtocol,
         local: FavoritePlacesProtocol) {
        googlePlaces = remote
        favoritePlaces = local
    }
    
    func nearbySearch(latitude: Double,
                      longitude: Double,
                      keyword: String?) -> AnyPublisher<[Place], Error> {
        
        // Repository will first execute a search against remote datasource
        // the map the remote data source models to local models, adding in isFavorite data from local datasource
        return googlePlaces.nearbySearch(type: searchType,
                                   latitude: latitude,
                                   longitude: longitude,
                                   radius: radius,
                                   keyword: keyword)
            // Convert GooglePlace model to Place model, adding isFavorite Data
            .map{ gp in
                var places = [Place]()
                for p in gp {
                    places.append(
                        Place(id: p.place_id,
                              name: p.name,
                              rating: p.rating,
                              totalRatings: p.user_ratings_total,
                              priceLevel: p.price_level,
                              favorite: favoritePlaces.isFavorite(p.place_id),
                              latitude: p.location().0,
                              longitude: p.location().1,
                              photo: nil)
                        )
                }
                return places}
            .eraseToAnyPublisher()

    }
    
    func favorite(_ place: Place) -> Place {
        return favoritePlaces.favorite(place)
    }
    
    func unfavorite(_ place: Place) -> Place {
        return favoritePlaces.unfavorite(place)
    }
    
    
}
