//
//  LoginSignUpViewController.swift
//  Wunderlist
//
//  Created by Cody Morley on 6/20/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import UIKit

class LoginSignUpViewController: UIViewController {
    //MARK: - Properties -
    ///later if we want to add a logo we can just substitute the placeholder photo using this property.
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var anchorView: UIView!
    
    var loggingIn: Bool = true
    
    
    //MARK: - Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    
    //MARK: - Actions -
    @IBAction func submit(_ sender: UIButton) {
        switch loggingIn {
        case true:
            statusLabel.text = "Logging Into Wunderlist, one moment..."
            ///TODO access auth controller for LOGIN here, use guard
            
            ///TODO put this in closure of call to auth controller
            //statusLabel.text = "Success!"
            
            ///TODO put this in else statement of guard
            //statusLabel.textColor = .systemRed
            //statusLabel.text = "Something went wrong."
            //return
            
        case false:
            statusLabel.text = "Joining Wunderlist, one moment..."
            ///TODO access auth controller for SIGNUP here, use guard
            
            ///TODO put this in closure of call to auth controller
            //statusLabel.text = "Success!"
            
            ///TODO put this in else statement of guard
            //statusLabel.textColor = .systemRed
            //statusLabel.text = "Something went wrong."
            //return
        }
        UserDefaults.standard.set(true, forKey: .loggedInKey)
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rememberMe(_ sender: UIButton) {
        UserDefaults.standard.set(usernameTextField.text, forKey: .userKey)
        UserDefaults.standard.set(passwordTextField.text, forKey: .passKey)
        rememberMeButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
    }
    
    
    
    //MARK: - Methods -
    private func updateViews() {
        navigationController?.navigationBar.isHidden = true
        autoFill()
        checkRememberMe()
        setUpViews()
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
}




