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
    var listId: Int?
    var dueDate: String?
    var isComplete: Bool?
    var isRepeated: Bool?
    var days: Int64?
    var endOn: String?
    var userId: Int
    
    enum ListCodingKeys: String, CodingKey {
       case listId = "id"
        case isComplete = "completed"
        case isRepeated = "recurring"
        case dueDate = "due_date"
        case userId = "user_id"
    }
}

struct ListRepresentations: Codable {
    let results: [ListRepresentation]
}
