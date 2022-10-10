//
//  HistoryOfRidesViewModel.swift
//  Move
//
//  Created by Daria Andrioaie on 03.10.2022.
//

import Foundation

class HistoryOfRidesViewModel: ObservableObject {
    @Published var rides: [Ride] = []
    @Published var isFetchingNextRides: Bool = false
    @Published var isFetchingFirstRides: Bool = true
    private var currentPage: Int = 0
    private let pageSize: Int = 7

    init() {
        getRidesOfUserPaginated { returnedRides in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.rides = returnedRides
                self.isFetchingFirstRides = false
            }
        }
    }
    
    func getNextPageOfRides() {
        print("fetching next page")
        isFetchingNextRides = true
        currentPage += 1
        getRidesOfUserPaginated { [weak self] returnedRides in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.rides += returnedRides
                self?.isFetchingNextRides = false
            }
        }
    }
    
    func getRidesOfUserPaginated(onRequestCompleted: @escaping ([Ride]) -> Void) {
        RidesAPIService().getRidesOfUserPaginated(pageNumber: currentPage, pageSize: pageSize) { result in
            switch result {
            case .success(let returnedRides):
                
                onRequestCompleted(returnedRides)
            case .failure(let apiError):
                
                if apiError.message != "No rides!" {
                    SwiftMessagesErrorHandler().handle(message: apiError.message)
                }
                onRequestCompleted([])
            }
        }
    }
    
    func hasReachedEndOfCollection(ride: Ride) -> Bool {
        guard let lastRide = rides.last else {
            return false
        }
        
        return lastRide._id == ride._id
    }
    
}
