//
//  MarketCollectionViewCell.swift
//  farm2Seoul-frontend-ios
//
//  Created by 강보현 on 2023/04/25.
//

import UIKit

class MarketCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var marketButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        marketButton.clipsToBounds = true
        marketButton.layer.cornerRadius = 15

    }
}
