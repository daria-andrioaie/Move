//
//  UnlockViewModel.swift
//  Move
//
//  Created by Daria Andrioaie on 27.09.2022.
//

import Foundation

class UnlockViewModel: ObservableObject {
    func sendUnlockRequest(scooterNumber: String, onUnlockSuccessful: @escaping () -> Void, onAPIError: @escaping (APIError) -> Void) -> Void {
        //TODO: change thehardcoded values with real ones
        
        let scanParameters = ["latitude": 46.769484, "longitude": 23.589884, "fromNFC": false] as [String : Any]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.3, execute: {
            let service = RidesAPIService()
            service.scanScooter(scooterNumber: scooterNumber, scanParemeters: scanParameters) { result in
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
