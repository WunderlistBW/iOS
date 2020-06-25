//
//  NetworkDataLoader.swift
//  Wunderlist
//
//  Created by Nonye on 6/22/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import Foundation

protocol NetworkDataLoader {
    func loadData(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: NetworkDataLoader {
    func loadData(using request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        dataTask(with: request) { data, response, error in
            completion(data, response, error)
        }.resume()
    }
}
