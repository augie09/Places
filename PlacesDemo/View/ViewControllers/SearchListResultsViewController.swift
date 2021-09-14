//
//  SearchListResultsViewController.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//

import UIKit

class SearchListResultsViewController: UIViewController, SearchChildVCProtocol {

    //MARK: INIT
    init(){
        super.init(nibName: "SearchListResultsViewController", bundle: nil)
    }

    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad: SearchListResultsViewController")
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear: SearchListResultsViewController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear: SearchListResultsViewController")
    }
    
}

