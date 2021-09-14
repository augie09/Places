//
//  PlaceCellDelegate.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/14/21.
//

import UIKit

protocol PlaceCellDelegate : AnyObject {
    
    /// Pass action of button press to delegate
    /// - Parameter sender: favorite button 
    func favoritePressed(_ sender: UITableViewCell)
    
    /// asks the remote datasource for a url to the photo reference
    /// - Parameter from: Place photo reference value
    func photoUrl(from reference: String) -> URL?
}
