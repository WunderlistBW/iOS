//
//  ListRepresentation.swift
//  Wunderlist
//
//  Created by Patrick Millet on 6/22/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import Foundation

struct ListRepresentation: Equatable, Codable {
    var name: String
    var dayOfWeek: Int?
    var listId: Int?
    var isRecurring: Bool?
    var dueDate: Date
    var isComplete: Bool?
}

struct ListRepresentations: Codable {
    let results: [ListRepresentation]
}
