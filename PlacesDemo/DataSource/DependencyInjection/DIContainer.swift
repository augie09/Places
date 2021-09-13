//
//  DIContainer.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//

import Foundation
import Swinject

class DIContainer {
    private let container = Container()
    
    func configure() {
        
        // Register our Datasources
        container.register(FavoritePlacesProtocol.self) { _ in
            FavoritePlaces.init()
        }
        container.register(GooglePlacesUrlProviderProtocol.self) { _ in
            GooglePlacesUrls.init()
        }
        container.register(GooglePlacesProtocol.self) { r in
            GooglePlacesService.init(apiKey: Bundle.main.googleApiKey(),
                                     urlProvider: r.resolve(GooglePlacesUrlProviderProtocol.self)!)
        }
        
        // Register our Repositories
        container.register(PlacesRepositoryProtocol.self) { r in
            PlacesRepository.init(remote: r.resolve(GooglePlacesProtocol.self)!,
                                  local: r.resolve(FavoritePlacesProtocol.self)!)
        }
        
    }
    
    func resolve<T>(type : T.Type) -> T? {
        let threadsafeContainer = container.synchronize()
        return threadsafeContainer.resolve(T.self)
    }
}
