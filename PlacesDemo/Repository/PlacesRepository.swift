//
//  PlacesRepository.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//
//  This implementation of PlacesRepositoryProtocol managed google remote datasource and favorites local datasource
//  Search results from remote datasource are combined with local favorites data and returned to viewmodel layer


import Foundation
import Combine

struct PlacesRepository : PlacesRepositoryProtocol {
    
    private let googlePlaces: GooglePlacesProtocol
    private let favoritePlaces: FavoritePlacesProtocol
    
    //FIXME:- these should be moved to a filter component when Filter UI is added
    private let searchType: GooglePlacesType = .restaurant
    
    init(remote: GooglePlacesProtocol,
         local: FavoritePlacesProtocol) {
        googlePlaces = remote
        favoritePlaces = local
    }
    
    func nearbySearch(latitude: Double,
                      longitude: Double,
                      radius: Int,
                      keyword: String?) -> AnyPublisher<[Place], Error> {
        
        // Repository will first execute a search against remote datasource
        // the map the remote data source models to local models, adding in isFavorite data from local datasource
        return googlePlaces.nearbySearch(type: searchType,
                                   latitude: latitude,
                                   longitude: longitude,
                                   radius: radius,
                                   keyword: keyword)
            // Convert GooglePlace model to Place model, adding isFavorite Data
            .map{ googlePlaces in
                var places = [Place]()
                for googlePlace in googlePlaces {
                    places.append(
                        place(from: googlePlace)
                    )
                }
                return places}
            .eraseToAnyPublisher()

    }
    
    /// Save a place as a favorite
    /// - Parameter place: Place
    func favorite(_ place: Place) -> Place {
        return favoritePlaces.favorite(place)
    }
    
    /// Remove a place from favorites
    /// - Parameter place: Place
    func unfavorite(_ place: Place) -> Place {
        return favoritePlaces.unfavorite(place)
    }
    
    /// asks the remote datasource for a url to the photo reference
    /// - Parameter from: Place photo reference value
    func photoUrl(from reference: String) -> URL? {
        return googlePlaces.photoUrl(from: reference)
    }
}

extension PlacesRepository {
    
    private func place(from googlePlace: GooglePlace) -> Place {
        return Place(id: googlePlace.place_id,
                     name: googlePlace.name,
                     rating: googlePlace.rating,
                     totalRatings: googlePlace.user_ratings_total,
                     priceLevel: googlePlace.price_level,
                     favorite: favoritePlaces.isFavorite(googlePlace.place_id), // Add Favorites Data
                     latitude: googlePlace.location().0,
                     longitude: googlePlace.location().1,
                     photo: googlePlace.photoReference()
            )
    }
}
