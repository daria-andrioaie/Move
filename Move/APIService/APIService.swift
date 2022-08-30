//
//  APIService.swift
//  Move
//
//  Created by Daria Andrioaie on 29.08.2022.
//

import Foundation
import Alamofire

class APIService {
    static func registerUser(username: String, email: String, password: String) {
        let registerParameters = ["username": username, "email": email, "password": password]
        
        AF.request("https://move-scooter.herokuapp.com/user/register", method: .post, parameters: registerParameters)
            .validate()
            .responseDecodable(of: User.self) { response in
                switch response.result {
                case .success(let userResponse):
                    let newUser = User(_id: userResponse._id, username: userResponse.username, email: userResponse.email, password: userResponse.password, status: userResponse.status)
                    
                    print("Hi, \(newUser.username)")
                    // save to current session
                    if let userData = try? JSONEncoder().encode(newUser) {
                        UserDefaults.standard.set(userData, forKey: "currentUser")
                    }
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
    
    static func loginUser(email: String, password: String) {
        let loginParameters = ["email": email, "password": password]
        
        AF.request("https://move-scooter.herokuapp.com/user/login", method: .post, parameters: loginParameters)
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let loginResponse):
                    let user = loginResponse.user
                    let token = loginResponse.token
                    
                    print("User: \(user)")
                    print("Token: \(token)")
                    
                    if let userData = try? JSONEncoder().encode(user) {
                        UserDefaults.standard.set(userData, forKey: "currentUser")
                        UserDefaults.standard.set(token, forKey: "userToken")
                    }
                
                case .failure(let error):
                    print("Error: \(error)")
                }
                
            }
    }
}
