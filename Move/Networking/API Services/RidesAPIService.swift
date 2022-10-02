//
//  RidesAPIService.swift
//  Move
//
//  Created by Daria Andrioaie on 27.09.2022.
//

import Foundation
import Alamofire

class RidesAPIService {
    private let userDefaultsService = UserDefaultsService()
    private let baseURL = "https://move-scooter.herokuapp.com/api/rides"
    
    func scanScooter(scooterNumber: String, onRequestCompleted: @escaping (Result<ScooterData, APIError>) -> Void) {
        guard let userToken = try? userDefaultsService.getUserToken() else {
            onRequestCompleted(.failure(APIError(message: "Can't find token in User Defaults!")))
            return
        }
        
        let header: HTTPHeaders = ["Authorization": "Bearer \(userToken)"]
        let path = baseURL + "/scan/\(scooterNumber)"
        
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
    
    func startRide(startRideParameters: Parameters, onRequestCompleted: @escaping (Result<Ride, APIError>) -> Void) -> Void {
        guard let userToken = try? userDefaultsService.getUserToken() else {
            onRequestCompleted(.failure(APIError(message: "Can't find token in User Defaults!")))
            return
        }
        print("Attempting to start ride with user token: \(userToken)")
        
        let header: HTTPHeaders = ["Authorization": "Bearer \(userToken)"]
        
        AF.request(self.baseURL, method: .post, parameters: startRideParameters, headers: header)
            .validate()
            .responseDecodable(of: Ride.self) { response in
                switch response.result {
                case .success(let ride):
                    //TODO: save ride in user defaults
                    onRequestCompleted(.success(ride))
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
