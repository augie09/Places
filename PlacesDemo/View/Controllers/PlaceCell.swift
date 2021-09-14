//
//  PlaceCell.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/14/21.
//

import UIKit

class PlaceCell: UITableViewCell {
    
    @IBOutlet var favorite: UIButton!
    @IBOutlet var quicklookContainerView : UIView!

    private weak var delegate : PlaceCellDelegate?
    
    lazy var placeQuickLookView : PlaceQuickLookView = {
        // init from xib
        let quicklookview = PlaceQuickLookView.loadFromNib()
        self.quicklookContainerView.addSubview(quicklookview)
        
        // add constraints for table cell
        quicklookview.leadingAnchor.constraint(equalTo:  quicklookContainerView.leadingAnchor).isActive = true
        quicklookview.topAnchor.constraint(equalTo:  quicklookContainerView.topAnchor).isActive = true
        quicklookview.bottomAnchor.constraint(equalTo:  quicklookContainerView.bottomAnchor).isActive = true
        quicklookview.trailingAnchor.constraint(equalTo:  quicklookContainerView.trailingAnchor).isActive = true

        return quicklookview
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func load(place: Place, delegate: PlaceCellDelegate){
        self.delegate = delegate
        
        placeQuickLookView.load(place: place, delegate: self)
        favorite.isSelected = place.favorite

    }
    
    @IBAction func favoritePressed(_ sender: Any) {
        print("favoritePressed")
        //favorite.isSelected = !favorite.isSelected
        if let delegate = delegate {
            delegate.favoritePressed(self)
        }
    }
    
}

extension PlaceCell : PlaceQuickLookViewDelegate {
    func photoUrl(from reference: String) -> URL? {
        if let delegate = delegate {
            return delegate.photoUrl(from: reference)
        }
        return nil
    }
}
