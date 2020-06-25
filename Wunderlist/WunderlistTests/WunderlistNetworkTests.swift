//
//  WunderlistNetworkTests.swift
//  WunderlistTests
//
//  Created by Cody Morley on 6/24/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import XCTest
@testable import Wunderlist

class WunderlistNetworkTests: XCTestCase {
    // MARK: - Properties -
    var goodLoader: MockDataLoader?
    var badLoader: MockDataLoader?
    
    // MARK: - Methods -
    override func setUpWithError() throws {
        var loaderGoodData = MockDataLoader(data: wunderlistEntriesJSON,
                                            response: HTTPURLResponse(url: URL(string: "https://wunderlist-api-2020.herokuapp.com/api/tasks")!,
                                                                      statusCode: 200,
                                                                      httpVersion: nil,
                                                                      headerFields: nil),
                                            error: nil)
        let error = NSError(domain: "com.NonyeE.Wunderlist", code: -1, userInfo: nil)
        var loaderBadData = MockDataLoader(data: nil,
                                           response: nil,
                                           error: error)
        self.goodLoader = loaderGoodData
        self.badLoader = loaderBadData
    }

    override func tearDownWithError() throws {
        goodLoader = nil
        badLoader = nil
    }

    // MARK: - Tests -
    func testFetchListEntriesFromServer() {
        let controller = NEUserController()
        let toComplete = expectation(description: "Wait for server to return data.")
        
        
    }
    
    func testListEntryUpdate() {
    }
    
    func testPostEntryToServer() {
    }
    
}
