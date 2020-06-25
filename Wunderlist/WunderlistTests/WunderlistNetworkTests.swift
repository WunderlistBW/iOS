//
//  WunderlistNetworkTests.swift
//  WunderlistTests
//
//  Created by Cody Morley on 6/24/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import XCTest
import Foundation
@testable import Wunderlist

class WunderlistNetworkTests: XCTestCase {
    // MARK: - Properties -
    var goodLoader: MockDataLoader?
    var errorLoader: MockDataLoader?
    var badResponseLoader: MockDataLoader?
    
    // MARK: - Methods -
    override func setUpWithError() throws {
        let loaderGoodData = MockDataLoader(data: wunderlistEntriesJSON,
                                            response: HTTPURLResponse(url: URL(string: "https://wunderlist-api-2020.herokuapp.com/api/tasks")!,
                                                                      statusCode: 200,
                                                                      httpVersion: nil,
                                                                      headerFields: ["Content-Type" : "JSON"]),
                                            error: nil)
        let error = NSError(domain: "com.NonyeE.Wunderlist", code: -1, userInfo: nil)
        let loaderWithError = MockDataLoader(data: nil,
                                           response: nil,
                                           error: error)
        let loaderWithBadResponse = MockDataLoader(data: nil,
                                                   response: HTTPURLResponse(url: URL(string: "https://wunderlist-api-2020.herokuapp.com/api/tasks")!,
                                                                             statusCode: 400,
                                                                             httpVersion: nil,
                                                                             headerFields: ["Content-Type" : "JSON"]),
                                                   error: nil)
        goodLoader = loaderGoodData
        errorLoader = loaderWithError
        badResponseLoader = loaderWithBadResponse
        
    }

    override func tearDownWithError() throws {
        goodLoader = nil
        errorLoader = nil
        badResponseLoader = nil
    }

    // MARK: - Tests -
    func testHandlesData() {
        guard let goodLoader = goodLoader else { XCTFail("Loader not found."); return }
        let controller = ListController(dataLoader: goodLoader)
        let listCount1 = controller.listCount
        let toComplete = expectation(description: "Wait for server to return data.")
        controller.fetchListFromServer { error in
            toComplete.fulfill()
            XCTAssertNil(error)
        }
        wait(for: [toComplete], timeout: 3)
        let listcount2 = controller.listCount
        XCTAssertTrue(listcount2 > listCount1)
    }
    func testHandlesBadResponse() {
        guard let badResponseLoader = badResponseLoader else { XCTFail("Loader not found.") ; return }
        let controller = ListController(dataLoader: badResponseLoader)
        let toResponse = expectation(description: "Server returns bad response.")
        controller.fetchListFromServer { error in
            toResponse.fulfill()
            XCTAssertNil(error)
        }
        wait(for: [toResponse], timeout: 2)
        XCTAssertTrue(controller.searchedListEntry.isEmpty)
    }
    func testHandlesError() {
        guard let errorLoader = errorLoader else { XCTFail("No loader found."); return }
        let controller = ListController(dataLoader: errorLoader)
        let toError = expectation(description: "Server returns an error.")
        controller.fetchListFromServer { error in
            toError.fulfill()
            XCTAssertNotNil(error)
        }
        wait(for: [toError], timeout: 2)
    }
}
