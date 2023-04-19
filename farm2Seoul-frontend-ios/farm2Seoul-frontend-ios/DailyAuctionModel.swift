//
//  DailyAuctionModel.swift
//  farm2Seoul-frontend-ios
//
//  Created by 강보현 on 2023/04/19.
//

import Foundation
import Alamofire

class DailyAuctionModel {
    var name: String = ""
    var price: Int = 0
    var weight: Int = 0
    var rank: String = ""
    init(name: String, price: Int, weight: Int, rank: String) {
        self.name = name
        self.price = price
        self.weight = weight
        self.rank = rank
    }
    
//    init(auctionDictionary: Dictionary<String, Any>) {
//
//    }
    
//    class func getDailyAuctionData(completion: @escaping ([DailyAuctionModel]) -> Void) {
//        AF.request(path).responseJSON()
//    }
}
