//
//  RecurringTask.swift
//  Wunderlist
//
//  Created by Chris Dobek on 6/25/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import Foundation

struct RecurringTask: Codable {
    var name: String
    var isRepeated: Bool?
    var days: Int
    var endOn: Date
}
