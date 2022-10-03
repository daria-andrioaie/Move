//
//  Buttons.swift
//  Move
//
//  Created by Daria Andrioaie on 30.09.2022.
//

import Foundation
import SwiftUI

struct LockUnlockButton: View {
    var scooterLockStatus: LockStatus
    let onLockUnlock: () -> Void
    
    var body: some View {
        Button(action: {
            onLockUnlock()
        }, label: {
            HStack {
                Image(scooterLockStatus == .locked ? "unlock" : "lock")
                Text(scooterLockStatus == .locked ? "Unlock" : "Lock")
            }
        })
        .frame(maxWidth: .infinity)
        .lightActiveButton()
    }
}


struct EndRideButton: View {
    let onEndRide: () -> Void
    
    var body: some View {
        Button("End ride") {
            onEndRide()
        }
        .frame(maxWidth: .infinity)
        .activeButton()
        .shadow(color: Color(red: 0.898, green: 0.188, blue: 0.384, opacity: 0.2), radius: 20, x: 7, y: 7)
    }
}
