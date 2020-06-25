//
//  MockDataLoader.swift
//  WunderlistTests
//
//  Created by Cody Morley on 6/24/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import Foundation
@testable import Wunderlist

class MockDataLoader: NetworkDataLoader {
    let data: Data?
    let response: URLResponse?
    let error: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    func loadData(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(self.data, self.response, self.error)
        }
    }
}
