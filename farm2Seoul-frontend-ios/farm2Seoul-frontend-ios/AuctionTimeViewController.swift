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
    
    
    @IBAction func garakButtonTapped(_ sender: UIButton) {
            // 가락버튼 true
            // 강서 false
            print("garak select")
            
            garakButton.backgroundColor = UIColor(named: "MainColor")
            gangseoButton.backgroundColor = UIColor(named: "AuctionTimeInfoButtonColor")
        garakButton.setTitleColor(UIColor.white, for: .normal)
        gangseoButton.setTitleColor(UIColor(named: "NotSelectedButtonTitleColor"), for: .normal)

            garakMarketView.isHidden = false
            gangseoMarketView.isHidden = true
            
            garakButton.isEnabled = false
            gangseoButton.isEnabled = true
    }
    
    @IBAction func gangseoButtonTapped(_ sender: UIButton) {
            // 가락버튼 false
            // 강서 true
            print("garak unselect")
            garakButton.backgroundColor = UIColor(named: "AuctionTimeInfoButtonColor")
            gangseoButton.backgroundColor = UIColor(named: "MainColor")
        garakButton.setTitleColor(UIColor(named: "NotSelectedButtonTitleColor"), for: .normal)

        gangseoButton.setTitleColor(UIColor.white, for: .normal)
            garakMarketView.isHidden = true
            gangseoMarketView.isHidden = false
            
            garakButton.isEnabled = true
            gangseoButton.isEnabled = false
    }

    func makeButton() {
        garakButton.backgroundColor = UIColor(named: "MainColor")
        gangseoButton.backgroundColor = UIColor(named: "AuctionTimeInfoButtonColor")
        
        garakButton.setTitleColor(UIColor.white, for: .normal)
        gangseoButton.setTitleColor(UIColor(named: "NotSelectedButtonTitleColor"), for: .normal)

        garakButton.isEnabled = false
        
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
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        backAction()
    }
    
    @objc func backAction() {
        dismiss(animated: true, completion: nil)
    }
}
