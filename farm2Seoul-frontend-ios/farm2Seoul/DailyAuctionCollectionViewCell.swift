//
//  DailyAuctionCollectionViewCell.swift
//  farm2Seoul-frontend-ios
//
//  Created by 강보현 on 2023/04/19.
//

import UIKit

class DailyAuctionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var rankImage: UIImageView!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func generateCell(dailyAuction:DailyAuctionResponse) {
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 2
        layer.masksToBounds = false
        
        weightLabel.text = String(dailyAuction.weight)
        nameLabel.text = dailyAuction.name
        priceLabel.text = String(numberFormatter(number: dailyAuction.avrPrice)) + "원"
        
        
        switch dailyAuction.rank {
        case "특":
            return rankImage.image = UIImage(named: "SpecialRankImage")
        case "상":
            return rankImage.image = UIImage(named: "HighRankImage")
        case "중":
            return rankImage.image = UIImage(named: "MiddleRankImage")
        case "하":
            return rankImage.image = UIImage(named: "LowRankImage")
        default:
            return rankImage.image = UIImage(named: "LowRankImage")
        }
        
    }
    
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
}
