//
//  HistoryOfRidesViewModel.swift
//  Move
//
//  Created by Daria Andrioaie on 03.10.2022.
//

import Foundation

class HistoryOfRidesViewModel: ObservableObject {
    @Published var rides: [Ride] = []
    @Published var numberOfRides: Int = 0
    
    init() {
        getRidesOfUser { returnedRides in
            self.rides = returnedRides
        }
        
        getNumberOfRidesOfUser { returnedNumberOfRides in
            self.numberOfRides = returnedNumberOfRides
        }
    }
    
    func getRidesOfUser(onRequestCompleted: @escaping ([Ride]) -> Void) {
        RidesAPIService().getRidesOfUser(pageNumber: 0, pageSize: 10) { result in
            switch result {
            case .success(let returnedRides):
                onRequestCompleted(returnedRides)
            case .failure(let apiError):
                SwiftMessagesErrorHandler().handle(message: apiError.message)
            }
        }
    }
    
    func getNumberOfRidesOfUser(onRequestCompleted: @escaping (Int) -> Void) {
        RidesAPIService().getNumberOfRidesOfUser(onRequestCompleted: { result in
            switch result {
            case .success(let returnedNumberOfRides):
                onRequestCompleted(returnedNumberOfRides)
            case .failure(let apiError):
                SwiftMessagesErrorHandler().handle(message: apiError.message)
            }
        })
    }
}
