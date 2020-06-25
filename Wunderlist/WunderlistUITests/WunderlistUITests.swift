//
//  WunderlistUITests.swift
//  WunderlistUITests
//
//  Created by Cody Morley on 6/22/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import XCTest
@testable import Wunderlist

class WunderlistUITests: XCTestCase {
    // MARK: - Properties -
    
    
    // MARK: - Methods -
    override func setUp() {
        let app = XCUIApplication()
        app.launchArguments = ["UITesting"]
        continueAfterFailure = false
        app.launch()
    }
    
    // MARK: - Tests -
    func testNewUserSignup() {
        //launch app
        //tap signup
        //enter text in text boxes
        // tap submit
        //test you're on home tableview
    }
    func testUserLoginAndRememberMe() {
        //launch app
        //tap login
        //enter text in text boxes
        //tap remember me
        //tap submit
        //test you're on home view
        //close app
        //launch app
        //tap login
        //test if testboxes have text autfilled
        //tap submit
        //test if back at home view
    }

    func testPasswordIncorrect() {
        //launch app
        //tap login
        //enter text in text boxes, password incorrect
        //test if still on login screen and status bar displays correct message
    }

    func testCreateListEntry() {
        //launch app
        //tap signup
        //enter text in text boxes
        //tap submit
        
        //tap add button
        //tap cancel
        //test at home tableview
        //test no new list
        
        //tap add button
        //enter text in text field
        //select date from picker
        //tap save
        //tap finished
        //test at home tableview
        //test new list entry is available
        //test UI element in tableview is in right mode for new entry
    }

    func testDeleteListEntry() {
        //launch app
        //tap signup
        //enter text in text boxes
        //tap submit
        //tap add button
        //enter text in text field
        //select date from picker
        //tap save
        //tap finished
        //test new list entry is available
        //slide to delete
        //test new list entry is no longer present
    }
}
