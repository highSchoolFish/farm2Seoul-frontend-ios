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
    var avrPrice: Int = 0
    var maxPrice: Int = 0
    var minPrice: Int = 0
    var weight: String = ""
    var rank: String = ""
    
    init(auctionDictionary :Dictionary<String,Any>) {
        let data = JSON(auctionDictionary)
        name = data["PUMNAME"].stringValue
        avrPrice = data["AVGPRICE"].intValue
        weight = data["UNITQTY"].stringValue + data["UNITNAME"].stringValue
        rank = data["GRADENAME"].stringValue
        minPrice = data["MINPRICE"].intValue
        maxPrice = data["MAXPRICE"].intValue
    }
    
}
