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
    private let baseURL = "https://move-scooter.herokuapp.com/api/scooters/near"
    
    func getScootersInArea(center: CLLocationCoordinate2D, radius: Int, onRequestCompleted: @escaping (Result<[ScooterData], APIError>) -> Void) {
        
        let parameters = ["longitude": center.longitude, "latitude": center.latitude]
        
        AF.request(self.baseURL, method: .get, parameters: parameters, encoding: URLEncoding.queryString)
            .validate()
            .responseDecodable(of: [ScooterData].self) { response in
                switch response.result {
                case .success(let scooters):
                    onRequestCompleted(.success(scooters))
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
