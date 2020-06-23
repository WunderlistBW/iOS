//
//  LoginSignUpViewController.swift
//  Wunderlist
//
//  Created by Cody Morley on 6/20/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import UIKit

class LoginSignUpViewController: UIViewController {
    // MARK: - Properties -
    ///later if we want to add a logo we can just substitute the placeholder photo using this property.
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var anchorView: UIView!
    var loggingIn: Bool?
    // MARK: - Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        createObservers()
    }
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillChangeFrameNotification,
                                                  object: nil)
    }
    // MARK: - Actions -
    @IBAction func submit(_ sender: UIButton) {
        guard let username = usernameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty,
            !password.isEmpty else { return }
        switch loggingIn {
        case true:
            statusLabel.text = "Logging Into Wunderlist, one moment..."
            let user = NEUser(username: username,
                              password: password)
            NEUserController.shared.signIn(with: user.username,
                                           password: user.password) { result in
                                            do {
                                                let loginResult = try result.get()
                                                if loginResult == true {
                                                    self.statusLabel.textColor = .white
                                                    self.statusLabel.text = "Success!"
                                                } else {
                                                    self.statusLabel.textColor = .systemRed
                                                    self.statusLabel.text = "Something went wrong."
                                                }
                                            } catch {
                                                NSLog("Error. Something horrific happened while trying to log you in. Here's some info about what happened \(error) \(error.localizedDescription)")
                                                return
                                            }
            }
        case false:
            statusLabel.text = "Joining Wunderlist, one moment..."
            let userWithOptions = presentOptions(for: username, with: password)
            NEUserController.shared.signUp(with: userWithOptions.username,
                                           password: userWithOptions.password,
                                           email: userWithOptions.email,
                                           name: userWithOptions.name) { result in
                                            do {
                                                let loginResult = try result.get()
                                                if loginResult == true {
                                                    self.statusLabel.textColor = .white
                                                    self.statusLabel.text = "Welcome to Wunderlist!"
                                                } else {
                                                    self.statusLabel.textColor = .systemRed
                                                    self.statusLabel.text = "Something went wrong."
                                                }
                                            } catch {
                                                NSLog("Error. Something horrific happened while trying to sign you up. Here's some info about what happened \(error) \(error.localizedDescription)")
                                                return
                                            }
            }
        @unknown default:
            print("Error with the loggin in boolean")
        }
        UserDefaults.standard.set(true, forKey: .loggedInKey)
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rememberMe(_ sender: UIButton) {
        UserDefaults.standard.set(usernameTextField.text, forKey: .userKey)
        UserDefaults.standard.set(passwordTextField.text, forKey: .passKey)
        rememberMeButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
    }
    @IBAction func textBeganEditing(_ sender: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5,
                                      execute: {
                                        self.rememberMeButton.alpha = 1
        })
    }
    @IBAction func textWasEdited(_ sender: UITextField) {
        checkRememberMe()
    }
    // MARK: - Methods -
    private func updateViews() {
        navigationController?.navigationBar.isHidden = true
        autoFill()
        checkRememberMe()
        setUpViews()
    }
    private func autoFill() {
        guard let user = UserDefaults.standard.object(forKey: .userKey) as? String,
            let password = UserDefaults.standard.object(forKey: .passKey) as? String else { return }
        usernameTextField.text = user
        passwordTextField.text = password
    }
    
    private func checkRememberMe() {
        if usernameTextField.text == UserDefaults.standard.object(forKey: .userKey) as? String &&
            passwordTextField.text == UserDefaults.standard.object(forKey: .passKey) as? String {
            rememberMeButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        } else {
            rememberMeButton.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }
    private func setUpViews() {
        passwordTextField.isSecureTextEntry = true
        submitButton.layer.cornerRadius = 5
        anchorView.layer.cornerRadius = 5
        anchorView.layer.shadowOpacity = 1
        anchorView.layer.shadowOffset = .zero
        anchorView.layer.shadowRadius = 10
        rememberMeButton.alpha = 0
        statusLabel.text = ""
    }
    private func presentOptions(for username: String,
                                with password: String) -> NEUser {
        var returnValue: NEUser?
        var unwrappedReturn: NEUser
        let options = UIAlertController(title: "Welcome!",
                                        message: "If you'd like you can help Wunderlist give you all the best featues by providing a little bit of optional info below:",
                                        preferredStyle: .alert)
        var name: UITextField!
        options.addTextField { textfield in
            name = textfield
            name.placeholder = "Name"
        }
        var email: UITextField!
        options.addTextField { textfield in
            email = textfield
            email.placeholder = "Email Address"
        }
        options.addAction(UIAlertAction(title: "Get Started!",
                                        style: .default,
                                        handler: { _ in
                                            switch name.text!.isEmpty {
                                            case true:
                                                switch email.text!.isEmpty {
                                                case true:
                                                    returnValue = NEUser(username: username,
                                                                         password: password)
                                                case false:
                                                    if let emailString = email.text {
                                                        returnValue = NEUser(username: username,
                                                                             password: password,
                                                                             email: emailString)
                                                    }
                                                }
                                            case false:
                                                if let nameString = name.text {
                                                    switch email.text!.isEmpty {
                                                    case true:
                                                        returnValue = NEUser(username: username,
                                                                             password: password,
                                                                             name: nameString)
                                                    case false:
                                                        if let emailString = email.text {
                                                            returnValue = NEUser(username: username,
                                                                                 password: password,
                                                                                 email: emailString,
                                                                                 name: nameString)
                                                        }
                                                    }
                                                }
                                            }
        }))
        present(options, animated: true, completion: nil)
        unwrappedReturn = returnValue!
        return unwrappedReturn
    }
    
    func createObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    @objc func keyboardWillChange(notification: Notification) {
        print("Keyboard will show: \(notification.name.rawValue)")
        view.frame.origin.y = -100
    }
}
