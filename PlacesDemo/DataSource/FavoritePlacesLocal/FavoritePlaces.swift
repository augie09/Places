//
//  FavoritePlaces.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//

import Foundation
import RealmSwift

class FavoritePlaces: FavoritePlacesProtocol {
    
    private let databaseSchemeVersion: UInt64 = 1
    private lazy var realm: Realm = { [self] in
        return try! Realm()
    }()
    
    func favorite(_ place: Place) -> Place {
        if let _ = favoriteRealmPlace(with: place.id) {
            // place is already a favorite
            return mutate(place, favorite: true)
        }
        
        try! realm.write({
            let realmPlace = realmPlace(from: place)
            realmPlace.favorite = true
            realm.add(realmPlace)
        })
        
        return mutate(place, favorite: true)
    }
    
    func unfavorite(_ place: Place) -> Place {
        guard !place.favorite else {
            //item already not favorite
            print("ERROR: item already not favorite ")
            return place
        }
        
        if let existingFavorite = favoriteRealmPlace(with: place.id) {
            //delete local favorite
            try! realm.write({
                realm.delete(existingFavorite)
            })
        }
        
        return mutate(place, favorite: false)
    }
    
    func isFavorite(_ id: String) -> Bool {
        
        guard let _ = favoriteRealmPlace(with: id) else {
            return false
        }
        return true
    }
    
}

extension FavoritePlaces {
    
    private func favoriteRealmPlace(with id: String) -> RealmPlace?{
        return realm.object(ofType: RealmPlace.self, forPrimaryKey: id)
    }
    
    private func mutate(_ place: Place, favorite: Bool) -> Place {
        return Place.init(id: place.id, name: place.name, rating: place.rating, totalRatings: place.totalRatings, priceLevel: place.priceLevel, favorite: favorite, latitude: place.latitude, longitude: place.longitude, photo: place.photo)
    }
    
    private func realmPlace(from place: Place) -> RealmPlace {
        let realmPlace = RealmPlace.init()
        realmPlace.ids = place.id
        realmPlace.name = place.name
        realmPlace.rating = place.rating ?? 0
        realmPlace.totalRatings = place.totalRatings ?? 0
        realmPlace.priceLevel = place.priceLevel ?? 0
        realmPlace.favorite = place.favorite
        realmPlace.latitude = place.latitude
        realmPlace.longitude = place.longitude
        realmPlace.photo = place.photo?.absoluteString ?? ""
        
        return realmPlace
    }
}

@objcMembers
class RealmPlace: Object {
    
    dynamic var ids: String = ""
    dynamic var  name: String = ""
    dynamic var  rating: Double = 0
    dynamic var  totalRatings:  Int = 0
    dynamic var  priceLevel: Int = 0
    dynamic var  favorite: Bool = false
    dynamic var  latitude: Double = 0
    dynamic var  longitude: Double = 0
    dynamic var  photo: String = ""
    
    override class func primaryKey() -> String? {
        return "ids"
    }

}
