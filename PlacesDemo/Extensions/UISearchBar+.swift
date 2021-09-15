//
//  UISearchBar+.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/14/21.
//

import UIKit

extension UISearchBar {
    
    func magnifyingTint(_ color: UIColor) {
        
        let glassIconView = self.searchTextField.leftView as! UIImageView
        glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
        glassIconView.tintColor = color
    }
}

