//
//  ThisWeekResponse.swift
//  farm2Seoul-frontend-ios
//
//  Created by 강보현 on 2023/04/26.
//

import Foundation

class ThisWeekResponse {
    let dayOfWeek: String
    let average: Int
    
    init(dayOfWeek: String, average: Int) {
            self.dayOfWeek = dayOfWeek
            self.average = average
        }
}
