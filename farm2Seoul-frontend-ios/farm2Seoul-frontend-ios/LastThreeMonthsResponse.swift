//
//  ThreeMonthsResponse.swift
//  farm2Seoul-frontend-ios
//
//  Created by 강보현 on 2023/04/27.
//

import Foundation

import Foundation
import SwiftyJSON

class LastThreeMonthsResponse: Codable {
    let month: Int
    let average: Int

    init(threeMonthsDictionary:Dictionary<String,Any>) {
        let data = JSON(threeMonthsDictionary)
        self.month = data["month"].int ?? 0
        self.average = data["average"].int ?? 0
    }
}
