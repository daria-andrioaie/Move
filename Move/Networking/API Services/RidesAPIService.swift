//
//  RidesAPIService.swift
//  Move
//
//  Created by Daria Andrioaie on 27.09.2022.
//

import Foundation
import Alamofire
import CoreLocation

class RidesAPIService {
    let userDefaultsService = UserDefaultsService()
    private let baseURL = "https://move-scooter.herokuapp.com/api/rides/scan"
    
    func scanScooter(scooterNumber: String, onRequestCompleted: @escaping (Result<ScooterData, APIError>) -> Void) {
        guard let userToken = try? userDefaultsService.getUserToken() else {
            onRequestCompleted(.failure(APIError(message: "Can't find token in User Defaults!")))
            return
        }
        print(scooterNumber)
        
        let header: HTTPHeaders = ["Authorization": "Bearer \(userToken)"]
        let path = baseURL + "/\(scooterNumber)"
        
        AF.request(path, method: .put, headers: header)
            .validate()
            .responseDecodable(of: ScooterData.self) { response in
                switch response.result {
                case .success(let scooter):
                    onRequestCompleted(.success(scooter))
                case .failure(let error):
                    if let data = response.data, let APIerror = try? JSONDecoder().decode(APIError.self, from: data) {
                        onRequestCompleted(.failure(APIerror))
                    }
                    else {
                        print("Unknown decoding error: \(error.localizedDescription)")
                    }
                }
            }
    }
 }
