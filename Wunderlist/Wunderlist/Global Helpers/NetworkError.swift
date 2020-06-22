//
//  NetworkError.swift
//  Wunderlist
//
//  Created by Chris Dobek on 6/22/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case noAuth
    case badAuth
    case otherError
    case badData
    case decodingError
}
