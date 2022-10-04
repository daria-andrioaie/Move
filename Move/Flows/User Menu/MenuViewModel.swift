//
//  MenuViewModel.swift
//  Move
//
//  Created by Daria Andrioaie on 04.10.2022.
//

import Foundation

class MenuViewModel: ObservableObject {
    @Published var numberOfRides: Int
    let userDefaultsService = UserDefaultsService()
    
    init() {
        do {
            let currentUser = try userDefaultsService.getUser()
            numberOfRides = currentUser.numberRides ?? 0
        }
        catch {
            numberOfRides = 0
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
