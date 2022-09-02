//
//  APIService.swift
//  Move
//
//  Created by Daria Andrioaie on 29.08.2022.
//

import Foundation
import Alamofire

class APIError: Error, Decodable {
    var message: String
}

class AuthenticationAPIService {
    static private let baseURL = "https://move-scooter.herokuapp.com/user/"
    
    static func registerUser(username: String, email: String, password: String, onRequestCompleted: @escaping (Result<AuthenticationRequestResponse, APIError>) -> Void) {
        let requestPath = baseURL + "register"
        let registerParameters = ["username": username, "email": email, "password": password]
                        
        AF.request(requestPath, method: .post, parameters: registerParameters)
            .validate()
            .responseDecodable(of: AuthenticationRequestResponse.self) { response in
                switch response.result {
                case .success(let registerResponse):
                    onRequestCompleted(.success(registerResponse))
                case .failure(let error):
                    if let data = response.data, let APIerror = try? JSONDecoder().decode(APIError.self, from: data) {
                        print("Error: \(APIerror.message)")
                        onRequestCompleted(.failure(APIerror))
                    }
                    else {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
    }
    
    static func loginUser(email: String, password: String, onRequestCompleted: @escaping (Result<AuthenticationRequestResponse, APIError>) -> Void) {
        let loginParameters = ["email": email, "password": password]
        let requestPath = baseURL + "login"

        
        AF.request(requestPath, method: .post, parameters: loginParameters, encoding: JSONEncoding.default, headers: .init(["Content-Type": "application/json"]))
            .validate()
            .responseDecodable(of: AuthenticationRequestResponse.self) { response in
                switch response.result {
                case .success(let loginResponse):
                    onRequestCompleted(.success(loginResponse))
                case .failure(let error):
                    if let data = response.data, let APIerror = try? JSONDecoder().decode(APIError.self, from: data) {
                        print("Error: \(APIerror.message)")
                        onRequestCompleted(.failure(APIerror))
                    }
                    else {
                        print("Error: \(error.localizedDescription)")
                    }
                }
                
            }
    }
}
