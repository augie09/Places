//
//  PlaceQuickLookView.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/14/21.
//

import UIKit
import Cosmos
import SDWebImage

class PlaceQuickLookView: UIView {

    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!
    @IBOutlet var ratings: CosmosView!
    @IBOutlet var thumbnail: UIImageView!
    
    private weak var delegate : PlaceQuickLookViewDelegate?

    static func loadFromNib() -> Self {
        let nib = UINib(nibName: "PlaceQuickLookView", bundle: nil)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! Self
        nibView.title.translatesAutoresizingMaskIntoConstraints = false
        nibView.subtitle.translatesAutoresizingMaskIntoConstraints = false
        nibView.translatesAutoresizingMaskIntoConstraints = false
        return nibView
    }
    
    func load(place: Place, delegate: PlaceQuickLookViewDelegate){
        title.text = place.name
        subtitle.text = "\(place.priceLevelSigns()) - Supporting Text"
        ratings.rating = place.rating ?? 0.0
        let totalRatings = place.totalRatings ?? 0
        ratings.text = "(\(totalRatings))"
        self.delegate = delegate
        
        if let photo = place.photo,
           let delegate = self.delegate,
           let photoUrl = delegate.photoUrl(from: photo) {
            thumbnail.sd_setImage(with: photoUrl, placeholderImage:UIImage.init(named: "thumbnail"))
        }
    }
    
}

protocol PlaceQuickLookViewDelegate: AnyObject {
    
    /// asks the remote datasource for a url to the photo reference
    /// - Parameter from: Place photo reference value
    func photoUrl(from reference: String) -> URL?
    
}
