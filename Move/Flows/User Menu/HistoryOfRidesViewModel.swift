//
//  HistoryOfRidesViewModel.swift
//  Move
//
//  Created by Daria Andrioaie on 03.10.2022.
//

import Foundation

class HistoryOfRidesViewModel: ObservableObject {
    @Published var rides: [Ride] = []

    init() {
        getRidesOfUser { returnedRides in
            self.rides = returnedRides
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
    
}
