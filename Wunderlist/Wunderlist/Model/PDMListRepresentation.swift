//
//  ListRepresentation.swift
//  Wunderlist
//
//  Created by Patrick Millet on 6/22/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import Foundation

struct ListRepresentation: Equatable, Codable, Persistable {
    var name: String
    var body: String?
    var id: Int64? // The post's ID
    var dueDate: String // ""YYYY-MM-DD HH:MM:SS"
    var completed: Bool? // defaults to false
    var recurring: String? // daily, weekly, monthly
    
    enum CodingKeys: String, CodingKey {
        case dueDate = "due_date"
        case name
        case body
        case id = "user_id"
        case completed
        case recurring
    }
}

struct ListRepresentations: Codable {
    let results: [ListRepresentation]
}
