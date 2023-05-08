//
//  LastFourWeeksResponse.swift
//  farm2Seoul-frontend-ios
//
//  Created by 강보현 on 2023/04/27.
//

import Foundation
import SwiftyJSON

class LastFourWeeksResponse: Codable {
    let weekName: String
    let averagePrice: Int

    init(fourWeeksDictionary:Dictionary<String,Any>) {
        let data = JSON(fourWeeksDictionary)
        self.weekName = data["weekName"].stringValue
        self.averagePrice = data["averagePrice"].int ?? 0
    }
}

