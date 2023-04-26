//
//  AuctionTimeViewController.swift
//  farm2Seoul-frontend-ios
//
//  Created by 강보현 on 2023/04/25.
//

import UIKit

class AuctionTimeViewController: UIViewController {
    
    @IBOutlet weak var garakMarketView: UIView!
    @IBOutlet weak var gangseoMarketView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var garakButton: UIButton!
    @IBOutlet weak var gangseoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeButton()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if garakButton.isSelected {
            // 가락버튼 true
            // 강서 false
            print("garak select")
            
            print("garak \(garakButton.isSelected)")
            print("gangseo \(gangseoButton.isSelected)")
            
            garakButton.isSelected = false
            gangseoButton.isSelected = true
            
            garakButton.backgroundColor = UIColor(named: "MainColor")
            gangseoButton.backgroundColor = UIColor(named: "AuctionTimeInfoButtonColor")
            
            garakMarketView.isHidden = false
            gangseoMarketView.isHidden = true
            
            garakButton.isEnabled = false
            gangseoButton.isEnabled = true
        }
        else {
            // 가락버튼 false
            // 강서 true
            print("garak unselect")
            
            print("garak \(garakButton.isSelected)")
            print("gangseo \(gangseoButton.isSelected)")
            garakButton.isSelected = true
            gangseoButton.isSelected = false
            garakButton.backgroundColor = UIColor(named: "AuctionTimeInfoButtonColor")
            gangseoButton.backgroundColor = UIColor(named: "MainColor")
            
            garakMarketView.isHidden = true
            gangseoMarketView.isHidden = false
            
            garakButton.isEnabled = true
            gangseoButton.isEnabled = false
        }
    }
    
    func makeButton() {
        // 가락버튼 true
        // 강서 false
        garakButton.isSelected = true
        gangseoButton.isSelected = false
        garakButton.backgroundColor = UIColor(named: "MainColor")
        gangseoButton.backgroundColor = UIColor(named: "AuctionTimeInfoButtonColor")
        
        garakButton.setTitleColor(UIColor.white, for: .normal)
        gangseoButton.setTitleColor(UIColor(named: "NotSelectedButtonTitleColor"), for: .normal)

        print("garak \(garakButton.isSelected)")
        print("gangseo \(gangseoButton.isSelected)")
        
        garakButton.isSelected = false
        gangseoButton.isSelected = true
        
        garakMarketView.isHidden = false
        gangseoMarketView.isHidden = true
        
        garakButton.isEnabled = false
        gangseoButton.isEnabled = true
        garakButton.clipsToBounds = true
        gangseoButton.clipsToBounds = true
        garakButton.layer.cornerRadius = 5
        gangseoButton.layer.cornerRadius = 5
        
        gangseoButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        gangseoButton.layer.shadowOpacity = 0.5
        gangseoButton.layer.shadowRadius = 2
        gangseoButton.layer.masksToBounds = false
        
        garakButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        garakButton.layer.shadowOpacity = 0.5
        garakButton.layer.shadowRadius = 2
        garakButton.layer.masksToBounds = false
    }
}
