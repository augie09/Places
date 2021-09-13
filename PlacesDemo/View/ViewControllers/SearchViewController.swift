//
//  SearchViewController.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//

import UIKit
import Combine

class SearchViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var filterButton: UIButton!
    
    private let viewModel : SearchViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    //MARK: INIT
    init(viewModel: SearchViewModelProtocol){
        self.viewModel = viewModel
        super.init(nibName: "SearchViewController", bundle: nil)
    }

    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()

    }

    //MARK: BINDING
    func bind() {
        viewModel.placesPublisher
            .receive(on: DispatchQueue.main)
            .sink{ places in
                print(places.count)
            }
            .store(in: &cancellables)
    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        print("search bar: \(searchText)")
        viewModel.textSubject.send(searchText)
    }

}
