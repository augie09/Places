//
//  SearchListResultsViewController.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//

import UIKit
import Combine

class SearchListResultsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private let viewModel : SearchViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []
    private let cellIdentifer = "PlaceCell"
    
    //MARK: INIT
    init(viewModel: SearchViewModelProtocol){
        self.viewModel = viewModel
        super.init(nibName: "SearchListResultsViewController", bundle: nil)
    }

    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad: SearchListResultsViewController")
        tableView.register(UINib(nibName: cellIdentifer, bundle: nil), forCellReuseIdentifier: cellIdentifer)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.systemGroupedBackground
        let topInset: CGFloat = 10
        tableView.contentInset.top = topInset
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear: SearchListResultsViewController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear: SearchListResultsViewController")
    }
    
    
    //MARK: BINDING
    func bind() {
        viewModel.placesPublisher
            .receive(on: RunLoop.main)
            .sink{ [weak self] places in
                self?.tableView.reloadData()  //FIXME:- reload is an expensive UI operation, suggest moving to diffable data source, but we'd need to handle MapKit view that is sharing this ViewModel.
            }
            .store(in: &cancellables)
    }
    
}

extension SearchListResultsViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
    }
}


extension SearchListResultsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.places.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer) as! PlaceCell
        cell.load(place: viewModel.places[indexPath.row], delegate: self)
        return cell
    }
}

extension SearchListResultsViewController : PlaceCellDelegate {
    func favoritePressed(_ sender: UITableViewCell) {
        print("SearchListResultsViewController: favoritePressed")
        guard let indexPath = tableView.indexPath(for: sender) else {
            return
        }
        
        viewModel.favoritePressed(for: indexPath)
    }
}
