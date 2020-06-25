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
    var listId: UUID
    var dueDate: Date
    var isComplete: Bool?
    
    enum ListCodingKeys: String, CodingKey {
       case listId = "id"
        case isComplete = "completed"
    }
}

struct ListRepresentations: Codable {
    let results: [ListRepresentation]
}
