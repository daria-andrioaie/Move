//
//  RideScooterViewModel.swift
//  Move
//
//  Created by Daria Andrioaie on 27.09.2022.
//

import Foundation
import SwiftUI

class RideScooterViewModel: ObservableObject {
    @Published var tripDetailsSheetMode = SheetDisplayMode.custom
    @Published var scooterData: ScooterData
    @Published var timeElapsed: Int
    @Published var distanceCovered: Int
    @Published var mapCenterAddress: String? = nil
    var mapViewModel: ScooterMapViewModel = .init()

    init(scooterData: ScooterData) {
        print("ride scooter view model instantiated")
        self.timeElapsed = 0
        self.distanceCovered = 0
        self.scooterData = scooterData
        startUpdatingElapsedTime()
        startUpdatingCoveredDistance()
        
        mapViewModel.onMapRegionChanged = { mapCenterAddress in
            withAnimation {
                self.mapCenterAddress = mapCenterAddress
            }
        }
    }
    
    func startUpdatingElapsedTime() {
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.timeElapsed = self.timeElapsed + 1
            print("\(self.timeElapsed) = \(self.timeElapsed.convertToHoursMinutesSecondsFormat())")
        }
    }

    
    func startUpdatingCoveredDistance() {
        _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            self.distanceCovered += 100
        }
    }
    
    
    func centerMapOnUserLocation() {
        mapViewModel.centerMapOnUserLocation()
    }
}
