//
//  User.swift
//  Wunderlist
//
//  Created by Nonye on 6/22/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import Foundation

struct NEUser: Codable {
    var username: String
    var password: String
    var email: String?
    var name: String?
}
