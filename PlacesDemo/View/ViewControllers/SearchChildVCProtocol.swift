//
//  SearchChildVCProtocol.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//

import UIKit

protocol SearchChildVCProtocol: UIViewController {
    func remove()
    func currentChild() -> Bool
}

extension SearchChildVCProtocol {
    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func currentChild() -> Bool {
        return parent != nil
    }
    
}
