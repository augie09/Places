//
//  UIViewController+.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/14/21.
//

import UIKit

extension UIViewController {
    
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
