//
//  String+Keys.swift
//  Wunderlist
//
//  Created by Cody Morley on 6/21/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

//Use this extension on the String type to hold all non-coding String keys for the project.
 

import Foundation

extension String {
    //MARK: - User Defaults -
    static let firstLaunchKey = "firstLaunch"
    static let loggedInKey = "loggedIn"
    static let userKey = "username"
    static let passKey = "password"
    
    
    //MARK: - Segues -
    static let goToSignupSegue = "GoToSignup"
    static let goToLoginSegue = "GoToLogin"
}