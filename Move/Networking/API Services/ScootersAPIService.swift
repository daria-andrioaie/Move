//
//  ScootersAPIService.swift
//  Move
//
//  Created by Daria Andrioaie on 09.09.2022.
//

import Foundation
import Alamofire
import CoreLocation

class ScootersAPIService {
    private let userDefaultsService = UserDefaultsService()
    private let baseURL = "https://move-scooter.herokuapp.com/api/scooters"
    
    func getScootersInArea(center: CLLocationCoordinate2D, radius: Int, onRequestCompleted: @escaping (Result<[ScooterData], APIError>) -> Void) {
        
        let requestPath = self.baseURL + "/near"
        let parameters = ["longitude": center.longitude, "latitude": center.latitude]
        
        AF.request(requestPath, method: .get, parameters: parameters, encoding: URLEncoding.queryString)
            .validate()
            .responseDecodable(of: [ScooterData].self) { response in
                switch response.result {
                case .success(let scooters):
//                    scooters.forEach { scooter in
//                        scooter.computeAddressBasedOnLocationCoordinates()
//                    }
                    onRequestCompleted(.success(scooters))
                case .failure(let error):
                    if let data = response.data, let APIerror = try? JSONDecoder().decode(APIError.self, from: data) {
                        onRequestCompleted(.failure(APIerror))
                    }
                    else {
                        print("Unknown decoding error: \(error.localizedDescription)")
                        onRequestCompleted(.failure(.defaultServerError))

                    }
                }
            }
    }
    
    func getScooterByNumber(scooterNumber: String, onRequestCompleted: @escaping (Result<ScooterData, APIError>) -> Void) {
        guard let userToken = try? userDefaultsService.getUserToken() else {
            onRequestCompleted(.failure(APIError(message: "Can't find token in User Defaults!")))
            return
        }
        
        let header: HTTPHeaders = ["Authorization": "Bearer \(userToken)"]
        let requestPath = self.baseURL + "/\(scooterNumber)"
        
        AF.request(requestPath, method: .get, headers: header)
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
                        onRequestCompleted(.failure(.defaultServerError))
                    }
                }
            }
    }
    
    func changeLockStatus(scooterNumber: String, newLockStatus: LockStatus, onRequestCompleted: @escaping (Result<ScooterData, APIError>) -> Void) {
        guard let userToken = try? userDefaultsService.getUserToken() else {
            onRequestCompleted(.failure(APIError(message: "Can't find token in User Defaults!")))
            return
        }
        
        let header: HTTPHeaders = ["Authorization": "Bearer \(userToken)"]
        
        let path: String
        switch newLockStatus {
        case .locked:
            path = baseURL + "/lock/\(scooterNumber)"
        case .unlocked:
            path = baseURL + "/unlock/\(scooterNumber)"
        }
        
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
                        onRequestCompleted(.failure(.defaultServerError))
                    }
                }
            }
    }
 }
