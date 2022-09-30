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
    
    var body: some View {
        Button(action: {
            print("lock scooter")
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
    var body: some View {
        Button("End ride") {
            print("end ride")
        }
        .frame(maxWidth: .infinity)
        .activeButton()
        .shadow(color: Color(red: 0.898, green: 0.188, blue: 0.384, opacity: 0.2), radius: 20, x: 7, y: 7)
    }
}
