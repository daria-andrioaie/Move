//
//  APIService.swift
//  Move
//
//  Created by Daria Andrioaie on 29.08.2022.
//

import Foundation
import Alamofire

class APIService {
    static func registerUser(name: String, email: String, password: String) {
        let registerParameters = ["name": name, "email": email, "password": "1234"]
        
//        AF.request("https://move-scooter.herokuapp.com/user/register", method: .post, parameters: registerParameters)
//            .responseString { response in
//                    print("Response String: \(response.value)")
//            }
//            .validate(statusCode: 200...200)
//            .responseDecodable(of: User.self) { response in
//                print("Hi, \(response.value?.name ?? "unknown")")
//            }

        AF.request("https://move-scooter.herokuapp.com/user/register", method: .post, parameters: registerParameters)
            .responseString { response in
                    print("Response: \(response)")
            }
    }
    
    static func loginUser(email: String, password: String) {
        
    }
}
