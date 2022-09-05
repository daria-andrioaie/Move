//
//  APIService.swift
//  Move
//
//  Created by Daria Andrioaie on 29.08.2022.
//

import Foundation
import Alamofire

//class APIError: Error, Decodable {
//    var message: String
//}

enum AuthenticationRequestType {
    case login
    case register
}

class AuthenticationAPIService {
    static private let baseURL = "https://move-scooter.herokuapp.com/user/"
    
    static func authenticationRequest(type: AuthenticationRequestType, parameters: Parameters, onRequestCompleted: @escaping (Result<AuthenticationRequestResponse, APIError>) -> Void) {
        var requestPath: String
        switch type {
        case .login:
            requestPath = baseURL + "login"
        case .register:
            requestPath = baseURL + "register"
        }
        
        AF.request(requestPath, method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: AuthenticationRequestResponse.self) { response in
                switch response.result {
                case .success(let authenticationResponse):
                    onRequestCompleted(.success(authenticationResponse))
                case .failure(let error):
                    if let data = response.data, let APIerror = try? JSONDecoder().decode(APIError.self, from: data) {
                        print("Error: \(APIerror.message)")
                        onRequestCompleted(.failure(APIerror))
                    }
                    else {
                        print("Unknown decoding error: \(error.localizedDescription)")
                    }
                }
            }
        
    }
}
