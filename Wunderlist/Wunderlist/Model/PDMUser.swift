//
//  User.swift
//  Wunderlist
//
//  Created by Patrick Millet on 6/22/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import Foundation

struct User: Codable, Hashable {
    var username: String
    var password: String
}

struct UserID: Codable, Hashable {
    var userId: Int?
}
