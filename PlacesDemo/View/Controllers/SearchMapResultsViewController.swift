//
//  SearchMapResultsViewController.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//

import UIKit
import Combine

class SearchMapResultsViewController: UIViewController {

    private let viewModel : SearchViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    //MARK: INIT
    init(viewModel: SearchViewModelProtocol){
        self.viewModel = viewModel
        super.init(nibName: "SearchMapResultsViewController", bundle: nil)
    }

    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad: SearchMapResultsViewController")
        
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear: SearchMapResultsViewController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear: SearchMapResultsViewController")
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
