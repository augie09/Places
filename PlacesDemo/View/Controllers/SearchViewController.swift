//
//  SearchViewController.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//
//  This is currenlty the root view in the root Navigation controller
//  This view controller provided a Search Controller and a Container for Search Result Controllers
//
//  The current toggle implementation of switching between children view controllers is basic
//  The state of which child controller is presented and the appearance of the toggle button
//    is currently managed by this view controller.
//      This can be improved.  Suggest looking into CollectionView with Paging enabled or PageViewControllers
//                                  and a state object

import UIKit
import Combine

class SearchViewController: UIViewController {

    // IBOutlets
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var childToggleButton: UIButton!
    @IBOutlet var containerView: UIView!
    
    // Dependencies
    private let viewModel : SearchViewModelProtocol
    private var childrenVC: [UIViewController]

    // Combine cancellables
    private var cancellables: Set<AnyCancellable> = []

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

        setupNavigationBar()

        toggle()
        
        viewModel.viewDidLoad()
    }
    
    // Search Controller Setup
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = viewModel.searchPlaceHolder
        searchController.searchBar.delegate = self
        searchController.searchBar.magnifyingTint(#colorLiteral(red: 0.2588235294, green: 0.5411764706, blue: 0.07450980392, alpha: 1))
        searchController.searchBar.tintColor = #colorLiteral(red: 0.2588235294, green: 0.5411764706, blue: 0.07450980392, alpha: 1)
        return searchController
    }()

    // Navigation Setup
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.addCustomBottomLine(color: UIColor.lightGray, height: 0.5)

        // prevent nav bar collapsing when user scrolls - borrowed from StackOverflow
        let dummyView = UIView()
        view.addSubview(dummyView)
        view.sendSubviewToBack(dummyView)
        
        //navigationItem.title = "Places"  //FIXME- localized string
        let logo : UIImage = #imageLiteral(resourceName: "logo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }

}

extension SearchViewController: UISearchBarDelegate {
    
    // Send all keystrokes to thew ViewModel
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        print("search bar: \(searchText)")
        viewModel.textSubject.send(searchText)
    }
}

//MARK: Children Management
//FIXME:- see comment at top, state management between toggle switch and children needs improvement
extension SearchViewController {
    
    @IBAction func toggleChild(_ sender: Any) {
        print("toggleChild pressed")
        toggle()
    }
    
    func add(childVC: UIViewController){
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childVC.didMove(toParent: self)
    }

    func toggle() {
        if childrenVC.first!.currentChild() {
            childrenVC.first?.remove()
            add(childVC: childrenVC.last!)
            
            childToggleButton.setImage(UIImage.init(named: "toggleList"), for: .normal)
            childToggleButton.setTitle("List", for: .normal)
        }
        else {
            childrenVC.last?.remove()
            add(childVC: childrenVC.first!)
        
            childToggleButton.setImage(UIImage.init(named: "togglePin"), for: .normal)
            childToggleButton.setTitle("Map", for: .normal)
        }
    }
}

