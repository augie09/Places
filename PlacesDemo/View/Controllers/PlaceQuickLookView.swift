//
//  PlaceQuickLookView.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/14/21.
//

import UIKit
import Cosmos

class PlaceQuickLookView: UIView {

    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!
    @IBOutlet var ratings: CosmosView!

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
        ratings.rating = place.rating ?? 0.0
        let totalRatings = place.totalRatings ?? 0
        ratings.text = "(\(totalRatings))"
    }
    
}
