//
//  DIContainer.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//

import Foundation
import Swinject
import SwinjectAutoregistration

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
        
        // Register ViewModels
        container.register(SearchViewModelProtocol.self) { r in
            SearchViewModel.init(repo: r.resolve(PlacesRepositoryProtocol.self)!)
        }
        
        // Register ViewControllers
        container.autoregister(SearchViewController.self, initializer: SearchViewController.init)
        
        
    }
    
    func resolve<T>(type : T.Type) -> T? {
        let threadsafeContainer = container.synchronize()
        return threadsafeContainer.resolve(T.self)
    }
}