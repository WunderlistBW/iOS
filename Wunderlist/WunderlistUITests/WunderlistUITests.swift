//
//  WunderlistUITests.swift
//  WunderlistUITests
//
//  Created by Cody Morley on 6/22/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import XCTest
import UIKit
@testable import Wunderlist

class WunderlistUITests: XCTestCase {
    // MARK: - Properties -
    var app: XCUIApplication?
    
    // MARK: - Methods -
    override func setUp() {
        app = XCUIApplication()
        guard let app = app else { return }
        app.launchArguments = ["UITesting"]
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        app?.terminate()
        self.app = nil
    }
    
    // MARK: - Tests -
    func testNewUserSignup() {
        guard let app = app else { XCTFail("Could not launch app."); return }
        let signup = app.buttons[.signupButton]
        let userBox = app.textFields[.usernameTextField]
        let passBox = app.secureTextFields[.passwordTextField]
        let submit = app.buttons[.submitButton]
        let getStarted = app.alerts[.presentOptions].buttons[.getStartedButton]
        let homeTable = app.tables[.listTableView]
        
        app.launch()
        app.activate()
        XCTAssertTrue(signup.exists)
        signup.tap()
        XCTAssertTrue(userBox.exists)
        XCTAssertTrue(passBox.exists)
        XCTAssertTrue(submit.exists)
        userBox.tap()
        userBox.typeText("NewUser123")
        passBox.tap()
        passBox.typeText("password")
        submit.tap()
        XCTAssertTrue(getStarted.exists)
        getStarted.tap()
        XCTAssertTrue(homeTable.exists)
    }
    
    func testPasswordIncorrect() {
        //launch app
        //tap login
        //enter text in text boxes, password incorrect
        //test if still on login screen and status bar displays correct message
    }
    
    func testUserLoginAndRememberMe() {
        guard let app = app else { XCTFail("Unable to launch app."); return }
        let login = app.buttons[.loginButton]
        let userBox = app.textFields[.usernameTextField]
        let passBox = app.secureTextFields[.passwordTextField]
        let rememberMe = app.buttons[.rememberMeButton]
        let submit = app.buttons[.submitButton]
        let getStarted = app.alerts[.presentOptions].buttons[.getStartedButton]
        let homeTable = app.tables[.listTableView]
        
        app.launch()
        app.activate()
        login.tap()
        userBox.tap()
        userBox.typeText("NewUser123")
        passBox.tap()
        passBox.typeText("password")
        rememberMe.tap()
        submit.tap()
        XCTAssertTrue(getStarted.exists)
        getStarted.tap()
        XCTAssertTrue(homeTable.exists)
        app.terminate()
        app.launch()
        app.activate()
        login.tap()
        XCTAssertNotNil(userBox.staticTexts)
        XCTAssertNotNil(passBox.staticTexts)
        submit.tap()
        getStarted.tap()
        XCTAssertTrue(homeTable.exists)
    }

    

    func testCreateListEntry() {
        guard let app = app else { XCTFail("Unable to launch app."); return }
        let login = app.buttons[.loginButton]
        let userBox = app.textFields[.usernameTextField]
        let passBox = app.secureTextFields[.passwordTextField]
        let rememberMe = app.buttons[.rememberMeButton]
        let submit = app.buttons[.submitButton]
        let getStarted = app.alerts[.presentOptions].buttons[.getStartedButton]
        let homeTable = app.tables[.listTableView]
        let add = app.buttons[.addButton]
        let save = app.buttons[.createSaveButton]
        let cancel = app.buttons[.createCancelButton]
        let listField = app.textFields[.createListTextField]
        let picker = app.datePickers[.createDatePicker]
        let finished = app.alerts[.finishedAlert].buttons[.finishedButton]

        app.launch()
        app.activate()
        login.tap()
        userBox.tap()
        userBox.typeText("NewUser123")
        passBox.tap()
        passBox.typeText("password")
        submit.tap()
        getStarted.tap()
        XCTAssertTrue(homeTable.exists)
        XCTAssertTrue(add.exists)
        add.tap()
        XCTAssertTrue(cancel.exists)
        XCTAssertTrue(save.exists)
        XCTAssertTrue(picker.exists)
        cancel.tap()
        XCTAssertFalse(picker.exists)
        add.tap()
        listField.typeText("My New To-Do")
        picker.adjust(toNormalizedSliderPosition: 5)
        save.tap()
        finished.tap()
        XCTAssertTrue(homeTable.exists)
        XCTAssertTrue(homeTable.cells.count > 0)
    }

    func testDeleteListEntry() {
        guard let app = app else { XCTFail("Unable to launch app."); return }
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
