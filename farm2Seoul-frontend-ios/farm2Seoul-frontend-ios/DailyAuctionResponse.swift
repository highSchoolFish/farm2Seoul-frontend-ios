//
//  DailyAuctionModel.swift
//  farm2Seoul-frontend-ios
//
//  Created by 강보현 on 2023/04/19.
//

import Foundation
import Alamofire
import SwiftyJSON

class DailyAuctionResponse {
    var name: String = ""
    var price: Int = 0
    var weight: String = ""
    var rank: String = ""
    
    init(auctionDictionary :Dictionary<String,Any>) {
        let data = JSON(auctionDictionary)
        name = data["PUMNAME"].stringValue
        price = data["AVGPRICE"].intValue
        weight = data["UNITQTY"].stringValue + data["UNITNAME"].stringValue
        rank = data["GRADENAME"].stringValue
    }
    
}
