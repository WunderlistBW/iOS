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
    var bearer: NEBearer?
    var currentUserID: NEUserID?
    
    private init () {
    }
    private let baseURL = URL(string: "https://wunderlist-api-2020.herokuapp.com")!
    private lazy var signUpURL = baseURL.appendingPathComponent("api/auth/register")
    private lazy var signInURL = baseURL.appendingPathComponent("api/auth/login")
    private lazy var editUserURL = baseURL.appendingPathComponent("api/users/")
    private lazy var fetchUserURL = baseURL.appendingPathComponent("api/users/")
    private lazy var jsonEncoder = JSONEncoder()
    private lazy var jsonDecoder = JSONDecoder()
    
    func signUp(with username: String, password: String, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        let user = NEUser(username: username, password: password)
        print("\(String(describing: loggedInUser))🧚🏿‍♀️")
        print("signUpURL = \(signUpURL.absoluteString)")
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { _, response, error in //TODO: Decode userID?
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
                completion(.success(true))
            }
            task.resume()
        } catch {
            NSLog("Error encoding user: \(error)")
            completion(.failure(.failedSignUp))
        }
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
                    self.bearer = try self.jsonDecoder.decode(NEBearer.self, from: data)
                    print("\(self.bearer)")
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
    func fetchUserFromServer(with userID: NEUserID, completion: @escaping (Result<APIUser, NetworkError>) -> Void = { _ in }) {
        let requestURL = fetchUserURL.appendingPathComponent("\(userID.userId)")
        print("\(userID)")
        print("fetchUserURL: \(requestURL)")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let token = self.bearer?.token else { return }
        request.setValue(token, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error fetching user: \(error)⚠️⚠️⚠️")
                completion(.failure(.otherError))
                return
            }
            guard let data = data else {
                NSLog("No data returned from server (fetching user).⚠️⚠️⚠️")
                completion(.failure(.noData))
                return
            }
            do {
                let apiUser = try self.jsonDecoder.decode(APIUser.self, from: data)
                completion(.success(apiUser))
            } catch {
                NSLog("Error deocding APIUser from server: \(error)⚠️⚠️⚠️")
                completion(.failure(.otherError))
            }
        }.resume()
    }
    func updateUser(with username: String, email: String, completion: @escaping (Result<Bool, NetworkError>) -> Void = { _ in }) {
        guard let userID = currentUserID else { return }
        let requestURL = editUserURL.appendingPathComponent("\(userID.userId)")
        print("editUserURL = \(requestURL.absoluteString)")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        guard let token = self.bearer?.token else { return }
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let editDictionary = ["username": username, "email": email]
            print(editDictionary)
            let jsonData = try jsonEncoder.encode(editDictionary)
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    NSLog("Updating user failed: \(error)⚠️⚠️⚠️")
                    completion(.failure(.otherError))
                    return
                }
                if let response = response as? HTTPURLResponse,
                    response.statusCode != 201 {
                    NSLog("Updating user failed, server status code = \(response.statusCode)⚠️⚠️⚠️")
                    completion(.failure(.otherError))
                    return
                }
                #warning("Save local state of loggedInUser")
                self.loggedInUser?.username = editDictionary["username"] ?? ""
                self.loggedInUser?.email = editDictionary["email"] ?? ""
                completion(.success(true))
            }
            task.resume()
        } catch {
            NSLog("Error updating User on Server: \(error)⚠️⚠️⚠️")
            completion(.failure(.failedUpdate))
        }
    }
}
