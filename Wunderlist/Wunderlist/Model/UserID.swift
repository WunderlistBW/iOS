//
//  UserID.swift
//  Wunderlist
//
//  Created by Nonye on 6/22/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import Foundation

struct NEUserID: Codable {
    var userId: Int
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}
