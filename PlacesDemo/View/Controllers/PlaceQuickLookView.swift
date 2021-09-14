//
//  PlaceQuickLookView.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/14/21.
//

import UIKit

class PlaceQuickLookView: UIView {

    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!

    static func loadFromNib() -> Self {
        let nib = UINib(nibName: "PlaceQuickLookView", bundle: nil)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! Self
        nibView.title.translatesAutoresizingMaskIntoConstraints = false
        nibView.subtitle.translatesAutoresizingMaskIntoConstraints = false
        nibView.translatesAutoresizingMaskIntoConstraints = false
        return nibView
    }
    
    func load(place: Place){
        title.text = place.name
        subtitle.text = "\(place.priceLevelSigns()) - Supporting Text"
    }
}
