//
//  APIService.swift
//  Move
//
//  Created by Daria Andrioaie on 29.08.2022.
//

import Foundation
import Alamofire

class AuthenticationAPIService {
    static private let baseURL = "https://move-scooter.herokuapp.com/user/"
    
    static func registerUser(username: String, email: String, password: String, onRegisterCompleted: @escaping (Result<User, Error>) -> Void) {
        let requestPath = baseURL + "register"
        let registerParameters = ["username": username, "email": email, "password": password]
        
        //TODO: refactoring
//        AF.request(requestPath, method: .post, parameters: registerParameters)
//            .validate()
//            .responseDecodable(of: User.self) { response in
//                switch response.result {
//                case .success(let userResponse):
//                    try? UserDefaultsManager.shared.saveUser(userResponse)
//                    onRegisterCompleted()
//                case .failure(let error):
//                    print("Error: \(error)")
//                }
//            }
        
        
//        AF.request(requestPath, method: .post, parameters: registerParameters)
//            .validate()
//            .responseData { response in
//                print(response)
//                switch response.result {
//                case .success(let user):
//                    do {
//                        let decodedUser = try JSONDecoder().decode(User.self, from: user)
//                        onRegisterCompleted(.success(decodedUser))
//                    }
//                    catch {
//                        print("Cannot convert JSON response to a User instance")
//                        onRegisterCompleted(.failure(CodingError.cannotDecodeUser))
//                    }
//                case .failure(let error):
//                    print("Inside request: \(error.errorDescription ?? "no error description")" )
//                    onRegisterCompleted(.failure(error))
//                }
//            }
        
//        AF.request(requestPath, method: .post, parameters: registerParameters)
//            .validate(statusCode: 200..<600)
//            .responseDecodable(of: User.self) { response in
//                switch response.result {
//                case .success(let user):
//                    onRegisterCompleted(.success(user))
//                case .failure(let error):
//                    print("error in request: \(error.localizedDescription)")
//                    onRegisterCompleted(.failure(error))
//                }
//            }            
    }
    
    static func loginUser(email: String, password: String, onLoginCompleted: @escaping () -> Void) {
        let loginParameters = ["email": email, "password": password]
        let requestPath = baseURL + "login"

        
        AF.request(requestPath, method: .post, parameters: loginParameters)
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let loginResponse):
                    try? UserDefaultsManager.shared.saveUser(loginResponse.user)
                    UserDefaultsManager.shared.saveUserToken(loginResponse.token)
                    onLoginCompleted()
                case .failure(let error):
                    print("Error: \(error)")
                }
                
            }
    }
}
