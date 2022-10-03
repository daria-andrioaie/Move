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
                        onRequestCompleted(.failure(.defaultServerError))
                    }
                }
            }
    }
    
    func startRide(startRideParameters: Parameters, onRequestCompleted: @escaping (Result<Ride, APIError>) -> Void) -> Void {
        guard let userToken = try? userDefaultsService.getUserToken() else {
            onRequestCompleted(.failure(APIError(message: "Can't find token in User Defaults!")))
            return
        }

        let header: HTTPHeaders = ["Authorization": "Bearer \(userToken)"]
        
        AF.request(self.baseURL, method: .post, parameters: startRideParameters, headers: header)
            .validate()
            .responseDecodable(of: Ride.self) { response in
                switch response.result {
                case .success(let ride):
                    onRequestCompleted(.success(ride))
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
    
    func endRide(rideId: String, endRideParameters: Parameters, onRequestCompleted: @escaping (Result<Ride, APIError>) -> Void) -> Void {
        guard let userToken = try? userDefaultsService.getUserToken() else {
            onRequestCompleted(.failure(APIError(message: "Can't find token in User Defaults!")))
            return
        }
        let header: HTTPHeaders = ["Authorization": "Bearer \(userToken)"]
        let path = baseURL + "/\(rideId)"
        
        AF.request(path, method: .put, parameters: endRideParameters, headers: header)
            .validate()
            .responseDecodable(of: Ride.self) { response in
                switch response.result {
                case .success(let ride):
                    onRequestCompleted(.success(ride))
                case .failure(let error):
                    if let data = response.data, let APIerror = try? JSONDecoder().decode(APIError.self, from: data) {
                        if APIerror.message == "ride already ended!" {
                            self.getRideById(rideId: rideId) { result in
                                switch result {
                                case .success(let ride):
                                    try? UserDefaultsService().saveRide(ride)
                                    onRequestCompleted(.success(ride))
                                case .failure(let apiError):
                                    onRequestCompleted(.failure(apiError))
                                }
                            }
                        }
                        onRequestCompleted(.failure(APIerror))
                    }
                    else {
                        print("Unknown decoding error: \(error.localizedDescription)")
                        onRequestCompleted(.failure(.defaultServerError))
                    }
                }
            }
    }
    
    func getRideById(rideId: String, onRequestCompleted: @escaping (Result<Ride, APIError>) -> Void) -> Void {
        guard let userToken = try? userDefaultsService.getUserToken() else {
            return
        }
        let header: HTTPHeaders = ["Authorization": "Bearer \(userToken)"]
        let path = baseURL + "/\(rideId)"
        
        AF.request(path, method: .get, headers: header)
            .validate()
            .responseDecodable(of: Ride.self) { response in
                switch response.result {
                case .success(let ride):
                    onRequestCompleted(.success(ride))
                case .failure(let error):
                    if let data = response.data, let APIerror = try? JSONDecoder().decode(APIError.self, from: data) {
                        print(APIerror.message)
                        onRequestCompleted(.failure(APIerror))
                    }
                    else {
                        print("Unknown decoding error: \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func getRidesOfUser(pageNumber: Int, pageSize: Int, onRequestCompleted: @escaping (Result<[Ride], APIError>) -> Void) -> Void {
        
        guard let userToken = try? userDefaultsService.getUserToken() else {
            return
        }
        let header: HTTPHeaders = ["Authorization": "Bearer \(userToken)"]
        let parameters = ["pageSize": pageSize, "pageNumber": pageNumber]
        
        AF.request(baseURL, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: header)
            .validate()
            .responseDecodable(of: [Ride].self) { response in
                switch response.result {
                case .success(let rides):
                    onRequestCompleted(.success(rides))
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
    
    func getNumberOfRidesOfUser(onRequestCompleted: @escaping (Result<Int, APIError>) -> Void) -> Void {
        guard let userToken = try? userDefaultsService.getUserToken() else {
            return
        }
        let header: HTTPHeaders = ["Authorization": "Bearer \(userToken)"]
        
        let url = "https://move-scooter.herokuapp.com/api/users/me"
        
        AF.request(url, method: .get, headers: header)
            .validate()
            .responseDecodable(of: User.self) { response in
                switch response.result {
                case .success(let user):
                    onRequestCompleted(.success(user.numberRides ?? 0))
                case .failure(let error):
                    if let data = response.data, let APIerror = try? JSONDecoder().decode(APIError.self, from: data) {
                        print(APIerror.message)
                        onRequestCompleted(.failure(APIerror))
                    }
                    else {
                        print("Unknown decoding error: \(error.localizedDescription)")
                    }
                }
            }

    }
 }
