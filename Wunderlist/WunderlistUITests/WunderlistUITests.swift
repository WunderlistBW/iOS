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
    // MARK: - Methods -
    override func setUp() {
        let app = XCUIApplication()
        app.launchArguments = ["UITesting"]
        continueAfterFailure = false
        app.launch()
    }
    
    
    // MARK: - Tests -
    func testNewUserSignup() {
        let app = XCUIApplication()
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
        let app = XCUIApplication()
        let login = app.buttons[.loginButton]
        let userBox = app.textFields[.usernameTextField]
        let passBox = app.secureTextFields[.passwordTextField]
        let submit = app.buttons[.submitButton]
        let status = app.staticTexts[.statusLabel]
        let homeTable = app.tables[.listTableView]
        
        app.launch()
        app.activate()
        login.tap()
        userBox.tap()
        userBox.typeText("NewUser123")
        passBox.tap()
        passBox.typeText("passwrd")
        XCTAssertTrue(status.exists)
        XCTAssertFalse(homeTable.exists)
    }
    
    func testUserLoginAndRememberMe() {
        let app = XCUIApplication()
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
        let app = XCUIApplication()
        let login = app.buttons[.loginButton]
        let userBox = app.textFields[.usernameTextField]
        let passBox = app.secureTextFields[.passwordTextField]
        let submit = app.buttons[.submitButton]
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
        XCTAssertTrue(homeTable.exists)
        XCTAssertTrue(add.exists)
        add.tap()
        XCTAssertTrue(cancel.exists)
        XCTAssertTrue(save.exists)
        XCTAssertTrue(picker.exists)
        cancel.tap()
        XCTAssertFalse(picker.exists)
        add.tap()
        listField.tap()
        listField.typeText("My New To-Do")
        picker.adjust(toNormalizedSliderPosition: 5)
        save.tap()
        finished.tap()
        XCTAssertTrue(homeTable.exists)
        XCTAssertTrue(homeTable.cells.count > 0)
    }

    func testEditListEntry() {
        let app = XCUIApplication()
        let login = app.buttons[.loginButton]
        let userBox = app.textFields[.usernameTextField]
        let passBox = app.secureTextFields[.passwordTextField]
        let submit = app.buttons[.submitButton]
        let homeTable = app.tables[.listTableView]
        let add = app.buttons[.addButton]
        let save = app.buttons[.createSaveButton]
        let listField = app.textFields[.createListTextField]
        let picker = app.datePickers[.createDatePicker]
        let finished = app.alerts[.finishedAlert].buttons[.finishedButton]
        let details = app.textViews[.editDetailsTextView]
        let saveEdit = app.buttons[.saveEditButton]
        
        app.launch()
        app.activate()
        login.tap()
        userBox.tap()
        userBox.typeText("NewUser123")
        passBox.tap()
        passBox.typeText("password")
        submit.tap()
        add.tap()
        listField.tap()
        listField.typeText("My Noo To-Do")
        picker.adjust(toNormalizedSliderPosition: 5)
        save.tap()
        finished.tap()
        homeTable.tap()
        details.tap()
        details.typeText("Some Details")
        saveEdit.tap()
        XCTAssertTrue(homeTable.exists)
    }
}
