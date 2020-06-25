//
//  String+Keys.swift
//  Wunderlist
//
//  Created by Cody Morley on 6/21/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import Foundation

extension String {
    // MARK: - User Defaults -
    static let firstLaunchKey = "firstLaunch"
    static let loggedInKey = "loggedIn"
    static let userKey = "username"
    static let passKey = "password"
    // MARK: - Segues -
    static let signupSegue = "Signup"
    static let loginSegue = "Login"
}
