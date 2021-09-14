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
    @IBOutlet var childToggleButton: UIButton!
    @IBOutlet var containerView: UIView!
    
    private let viewModel : SearchViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    private var childrenVC: [UIViewController]
    
    //MARK: INIT
    init(viewModel: SearchViewModelProtocol, childrenVC: [UIViewController]) {
        self.viewModel = viewModel
        self.childrenVC = childrenVC
        super.init(nibName: "SearchViewController", bundle: nil)
    }

    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad: \(childrenVC.count)")
        toggle()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        print("search bar: \(searchText)")
        viewModel.textSubject.send(searchText)
    }
}

//FIXME:- probably should explore UIPageViewController option, or at least CollectionView with paging enabled
extension SearchViewController {
    
    @IBAction func toggleChild(_ sender: Any) {
        print("toggleChild pressed")
        toggle()
    }
    
    func add(childVC: UIViewController){
        print("add")
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childVC.didMove(toParent: self)
    }

    func toggle() {
        if childrenVC.first!.currentChild() {
            print("childrenVC.first!.currentChild()")
            childrenVC.first?.remove()
            add(childVC: childrenVC.last!)
        }
        else {
            print("NOT childrenVC.first!.currentChild()")
            childrenVC.last?.remove()
            add(childVC: childrenVC.first!)
        }
    }
}
