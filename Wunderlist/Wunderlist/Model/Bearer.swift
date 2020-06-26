//
//  Bearer.swift
//  Wunderlist
//
//  Created by Nonye on 6/22/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import Foundation

struct SignedInUser: Codable {
 // MARK: - SignedInUser
        var token: String
        var user: User

    // MARK: - User
    struct User: Codable {
        var id: Int64
    }
}
