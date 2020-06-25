//
//  UserController.swift
//  Wunderlist
//
//  Created by Nonye on 6/22/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import Foundation

protocol UserStateDelegate {
    func userLoggedIn()
}

class NEUserController {
    var dataLoader: NetworkDataLoader?
    init(dataLoader: NetworkDataLoader = URLSession.shared) {
        self.dataLoader = dataLoader
    }
    struct APIUser: Codable {
        var id: Int
        var username: String
        var email: String
    }
    enum NetworkError: Error {
        case failedSignUp, failedSignIn, noData, badData, noToken, failedLogOut, otherError, failedUpdate
    }
    // MARK: - Properties
    static let shared = NEUserController()
    var loggedInUser: APIUser?
    var delegate: UserStateDelegate?
    static var currentUserID: SignedInUser?
    private init () {
    }
    private let baseURL = URL(string: "https://wunderlist-node.herokuapp.com")!
    private lazy var signUpURL = baseURL.appendingPathComponent("api/register")
    private lazy var signInURL = baseURL.appendingPathComponent("api/login")
    private lazy var editUserURL = baseURL.appendingPathComponent("api/users/")
    private lazy var fetchUserURL = baseURL.appendingPathComponent("api/users/")
    private lazy var jsonEncoder = JSONEncoder()
    private lazy var jsonDecoder = JSONDecoder()
    func signUp(with username: String, password: String, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        let user = NEUser(username: username, password: password, email: "testing12@testing.com") // implement this in UI
        print("\(String(describing: loggedInUser))🧚🏿‍♀️")
        print("signUpURL = \(signUpURL.absoluteString)")
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user from userController")
        }
        _ = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    NSLog("Sign up failed with error: \(error)⚠️⚠️⚠️")
                    completion(.failure(.failedSignUp))
                    return
                }
                if let response = response as? HTTPURLResponse,
                    response.statusCode != 201 {
                    NSLog("Unexpected status code :\(response.statusCode)")
                    completion(.failure(.failedSignIn))
                    return
                }
                if let data = data {
                    do {
                        try NEUserController.self.currentUserID = self.jsonDecoder.decode(SignedInUser.self, from: data)
                        print("UserID:\(NEUserController.currentUserID)")
                    } catch {
                        print("Error decoding userID object")
                        completion(.failure(.failedSignUp))
                    }
                }
                completion(.success(true))
        }.resume()
    }
    
    func signIn(with username: String, password: String, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        print("signInURL = \(signInURL.absoluteString)")
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let signInUser = NEUser(username: username, password: password)
            print(signInUser)
            let jsonData = try jsonEncoder.encode(signInUser)
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    NSLog("Sign in failed with error: \(error)⚠️⚠️⚠️")
                    completion(.failure(.failedSignIn))
                    return
                }
                if let response = response as? HTTPURLResponse,
                    response.statusCode != 200 {
                    NSLog("Sign in was unsuccessful, server status code = \(response.statusCode)⚠️⚠️⚠️")
                    completion(.failure(.failedSignIn))
                    return
                }
                guard let data = data else {
                    NSLog("No data received during sign in.⚠️⚠️⚠️")
                    completion(.failure(.noData))
                    return
                }
                do {
                    NEUserController.self.currentUserID = try self.jsonDecoder.decode(SignedInUser.self, from: data)
                    print("Bearer Token: \(String(describing: NEUserController.self.currentUserID))")
                } catch {
                    NSLog("Error decoding bearer object: \(error)⚠️⚠️⚠️")
                    completion(.failure(.noToken))
                }
                self.delegate?.userLoggedIn()
                completion(.success(true))
            }
            task.resume()
        } catch {
            NSLog("Error encoding user: \(error)⚠️⚠️⚠️")
            completion(.failure(.failedSignIn))
        }
    }
}
