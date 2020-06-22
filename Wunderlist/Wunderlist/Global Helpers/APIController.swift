//
//  APIController.swift
//  Wunderlist
//
//  Created by Chris Dobek on 6/22/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class APIController {
    static let sharedInstance = APIController()
    private let baseURL = URL(string: "https://wunderlist-api-2020.herokuapp.com/")!
    private lazy var signInURL = baseURL.appendingPathComponent("/api/auth/login")
    private lazy var signUpURL = baseURL.appendingPathComponent("/api/auth/register")
}
