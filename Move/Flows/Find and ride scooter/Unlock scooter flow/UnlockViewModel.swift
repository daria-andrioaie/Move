//
//  UnlockViewModel.swift
//  Move
//
//  Created by Daria Andrioaie on 27.09.2022.
//

import Foundation

class UnlockViewModel: ObservableObject {
    func sendUnlockRequest(scooterNumber: String, onUnlockSuccessful: @escaping () -> Void, onAPIError: @escaping (APIError) -> Void) -> Void {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.3, execute: {
            let service = RidesAPIService()
            service.scanScooter(scooterNumber: scooterNumber) { result in
                switch result {
                case .success(_):
                    onUnlockSuccessful()
                case .failure(let error):
                    onAPIError(error)
                }
            }
        })
    }
}
