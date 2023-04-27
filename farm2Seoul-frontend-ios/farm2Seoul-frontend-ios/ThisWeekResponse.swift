//
//  ThisWeekResponse.swift
//  farm2Seoul-frontend-ios
//
//  Created by 강보현 on 2023/04/26.
//

import Foundation
import SwiftyJSON

class ThisWeekResponse: Codable {
    let dayOfWeek: String
    let average: Int

    init(thisWeekDictionary:Dictionary<String,Any>) {
        let data = JSON(thisWeekDictionary)
        self.dayOfWeek = data["dayOfWeek"].stringValue
        self.average = data["average"].int ?? 0
    }
}

