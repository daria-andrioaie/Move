//
//  UnlockViewModel.swift
//  Move
//
//  Created by Daria Andrioaie on 27.09.2022.
//

import Foundation

class UnlockViewModel: ObservableObject {
    func sendUnlockRequest(scooterNumber: String, onUnlockSuccessful: @escaping () -> Void) -> Void {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.3, execute: {
            onUnlockSuccessful()
        })
    }
}
