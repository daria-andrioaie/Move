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
    let userDefaultsManager: UserDefaultsManager
    static private let baseURL = "https://move-scooter.herokuapp.com/user/"
    
    init(userDefaultsManager: UserDefaultsManager) {
        self.userDefaultsManager = userDefaultsManager
    }
    
    func authenticationRequest(type: AuthenticationRequestType, parameters: Parameters, onRequestCompleted: @escaping (Result<AuthenticationRequestResponse, APIError>) -> Void) {
        var requestPath: String
        switch type {
        case .login:
            requestPath = AuthenticationAPIService.baseURL + "login"
        case .register:
            requestPath = AuthenticationAPIService.baseURL + "register"
        }
        
        AF.request(requestPath, method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: AuthenticationRequestResponse.self) { response in
                switch response.result {
                case .success(let authenticationResponse):
                    try? self.userDefaultsManager.saveUser(authenticationResponse.user)
                    self.userDefaultsManager.saveUserToken(authenticationResponse.token)
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
    
    func uploadDrivingLicenseRequest(image: UIImage, onRequestCompleted: @escaping (Result<User, APIError>) -> Void) {
        
        guard let userToken = try? userDefaultsManager.getUserToken() else {
            onRequestCompleted(.failure(APIError(message: "Can't find token in User Defaults!")))
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.85) else {
            onRequestCompleted(.failure(APIError(message: "Can't compress image")))
            return
        }
//            let parameters = ["token": userToken]
        let header: HTTPHeaders = ["Authorization": "Bearer \(userToken)"]
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "driverLicenseKey", fileName: "\(userToken).jpeg", mimeType: "image/jpeg")
//                for(key, value) in parameters {
//                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//                }
        }, to: "https://move-scooter.herokuapp.com/user/upload", method: .put, headers: header)
        .validate()
        .responseDecodable(of: User.self) { response in
            switch response.result {
            case .success(let user):
                try? self.userDefaultsManager.saveUser(user)
                onRequestCompleted(.success(user))
            case .failure(let error):
                if let data = response.data {
                    print(data.debugDescription)
                    if let APIerror = try? JSONDecoder().decode(APIError.self, from: data) {
                        print("Error: \(APIerror.message)")
                        onRequestCompleted(.failure(APIerror))
                    }
                    else {
                        print("Unknown decoding error of APIError: \(error.localizedDescription)")
                    }
                }
                else {
                    print("Nothing in response.data: \(error.localizedDescription)")
                }
                
                
            }
        }
    }
}
