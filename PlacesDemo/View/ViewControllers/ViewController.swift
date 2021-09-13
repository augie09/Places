//
//  ViewController.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/12/21.
//

import UIKit
import Swinject
import Combine

class ViewController: UIViewController {

    let container = DIContainer.init()
    var cancellableSet: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        container.configure()
        
        let repo = container.resolve(type: PlacesRepositoryProtocol.self)!
        repo.nearbySearch(latitude: -33.8670522,
                          longitude: 151.1957362,
                          keyword: nil)
            .sink(receiveCompletion: { completion in
                print("receiveCompletion")
            }, receiveValue: { places in
                places.forEach { p in
                    print("Place: \(p.name): isFavorite:\(p.favorite)")
                }
            })
            .store(in: &cancellableSet)
    }


}

