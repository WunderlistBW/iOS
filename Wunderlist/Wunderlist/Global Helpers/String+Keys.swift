//
//  String+Keys.swift
//  Wunderlist
//
//  Created by Cody Morley on 6/21/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

///Use this extension on the String type to hold all non-coding String keys for the project.
/// call these values by using .yourMagicString i.e .userKey
import Foundation

extension String {
    // MARK: - User Defaults -
    static let firstLaunchKey = "firstLaunch"
    static let loggedInKey = "loggedIn"
    static let userKey = "username"
    static let passKey = "password"
    // MARK: - Segues -
    static let signupSegue = "Signup"
    static let loginSegue = "Login"
    // MARK: - Storyboard IDs -
    //Onboarding
    ///Views
    static let presentOptions = "Onboarding.UIAlert"
    ///Buttons
    static let signupButton = "Onboarding.SignUpButton"
    static let loginButton = "Onboarding.LoginButton"
    static let submitButton = "Onboarding.SubmitButton"
    static let rememberMeButton = "Onboarding.RememberMeButton"
    static let getStartedButton = "Onboarding.UIAlert.GetStarted"
    ///Text Fields
    static let usernameTextField = "Onboarding.UserField"
    static let passwordTextField = "Onboarding.PasswordField"
    ///Labels
    static let statusLabel = "Onboarding.StatusLabel"
    //Main
    ///Views
    static let listTableView = "Main.ListTable"
    static let createDatePicker = "Main.Create.DatePicker"
    static let finishedAlert = "Main.Create.UIAlert"
    ///Buttons
    static let addButton = "Main.AddButton"
    static let createCancelButton = "Main.Create.CancelButton"
    static let createSaveButton = "Main.Create.SaveButton"
    static let finishedButton = "Main.Create.FinishedButton"
    static let saveEditButton = "Main.Edit.SaveEditButton"
    ///Text Fields
    static let createListTextField = "Main.Create.TextField"
    ///Text Views
    static let editDetailsTextView = "Main.Edit.DetailTextView"
}
