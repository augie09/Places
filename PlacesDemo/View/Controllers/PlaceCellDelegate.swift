//
//  PlaceCellDelegate.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/14/21.
//

import UIKit

protocol PlaceCellDelegate : AnyObject {
    func favoritePressed(_ sender: UITableViewCell)
}
