//
//  TcpAPIService.swift
//  Move
//
//  Created by Daria Andrioaie on 01.10.2022.
//

import Foundation
import Alamofire

class TcpAPIService {
    private let userDefaultsService = UserDefaultsService()
    private let baseURL = "https://move-scooter.herokuapp.com/api/tcp"

    func pingScooter(scooterNumber: String, userLocationCoordinates: Parameters, onRequestCompleted: @escaping (Result<String, APIError>) -> Void) {
        guard let userToken = try? userDefaultsService.getUserToken() else {
            onRequestCompleted(.failure(APIError(message: "Can't find token in User Defaults!")))
            return
        }
        
        let header: HTTPHeaders = ["Authorization": "Bearer \(userToken)"]
        let path = baseURL + "/\(scooterNumber)"
        
        
        AF.request(path, method: .post, parameters: userLocationCoordinates, headers: header)
            .validate()
            .responseString(completionHandler: { response in
                switch response.result {
                case .success(let successString):
                    onRequestCompleted(.success(successString))
                case .failure(let error):
                    if let data = response.data, let APIerror = try? JSONDecoder().decode(APIError.self, from: data) {
                        onRequestCompleted(.failure(APIerror))
                    }
                    else {
                        print("Unknown decoding error: \(error.localizedDescription)")
                        onRequestCompleted(.failure(.defaultServerError))
                    }
                }
            })
    }

}

