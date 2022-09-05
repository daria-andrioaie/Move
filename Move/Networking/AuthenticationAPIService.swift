//
//  APIService.swift
//  Move
//
//  Created by Daria Andrioaie on 29.08.2022.
//

import Foundation
import Alamofire
import SwiftUI

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
    
    static func uploadDrivingLicenseRequest(image: UIImage, userToken: String, onRequestCompleted: @escaping (Result<User, APIError>) -> Void) {
        if let imageData = image.jpegData(compressionQuality: 0.85) {
            let parameters = ["token": userToken]
            
            
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "driverLicenseKey", fileName: "\(userToken).jpeg", mimeType: "image/jpeg")
                for(key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }, to: "https://move-scooter.herokuapp.com/user/upload")
            .validate()
            .responseDecodable(of: User.self) { response in
                switch response.result {
                case .success(let user):
                    onRequestCompleted(.success(user))
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
        // cannot compress image
    }
}
