//
//  WunderlistTests.swift
//  WunderlistTests
//
//  Created by Chris Dobek on 6/22/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import XCTest
@testable import Wunderlist

class WunderlistTests: XCTestCase {
    func testSignUp() {
        let login = UserController()
        let user = User(username: "Chris", password: "12345")
        let expectation = self.expectation(description: "Waiting for signing up to complete")
        login.signUp(with: user) { error in
            if let error = error {
                NSLog("Error signing up: \(error)")
            }
            XCTAssertNoThrow(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    func testSignIn() {
        let login = UserController()
        let user = User(username: "Chris", password: "12345")
        let expectation = self.expectation(description: "Waiting to be signed in")
        login.signIn(with: user) { error in
            if let error = error {
                NSLog("Error signing in: \(error)")
            }
            XCTAssertNoThrow(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        XCTAssertNotNil(login.bearer)
    }
}
