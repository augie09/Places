//
//  PlaceCell.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/14/21.
//

import UIKit

class PlaceCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!
//    @IBOutlet var thumbnail: UIImageView!
//    @IBOutlet var favorite: UIButton!
//    @IBOutlet var ratings: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func load(place: Place){
        title.text = place.name
        subtitle.text = "\(place.priceLevelSigns()) - Supporting Text"
    }
    
}
