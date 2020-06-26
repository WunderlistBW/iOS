//
//  Task.swift
//  Wunderlist
//
//  Created by Patrick Millet on 6/24/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import Foundation

struct Task: Codable {

    var task: [ListRepresentation]
    enum TaskCodingKey: String, CodingKey {
        case task = "Tasks"
    }
}
