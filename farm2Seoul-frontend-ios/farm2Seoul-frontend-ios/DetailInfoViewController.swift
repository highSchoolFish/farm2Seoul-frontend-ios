//
//  DetailInfoBoardViewController.swift
//  farm2Seoul-frontend-ios
//
//  Created by 강보현 on 2023/04/18.
//

import UIKit

class DetailInfoViewController: UIViewController {
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var rankImage: UIImageView!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var averagePriceLabel: UILabel!
    @IBOutlet weak var maximumPriceLabel: UILabel!
    @IBOutlet weak var minimumPriceLabel: UILabel!
    @IBOutlet weak var thisWeakButton: UIButton!
    @IBOutlet weak var lastFourWeaksButton: UIButton!
    @IBOutlet weak var lastThreeMonthsButton: UIButton!
    @IBOutlet weak var graphView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
