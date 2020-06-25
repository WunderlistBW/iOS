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
    var completed: Bool?
    var recurring: Bool?
    var body: String?
    enum ListCodingKeys: String, CodingKey {
       case listId = "id"
    }
}

struct ListRepresentations: Codable {
    let results: [ListRepresentation]
}
