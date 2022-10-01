//
//  RideScooterViewModel.swift
//  Move
//
//  Created by Daria Andrioaie on 27.09.2022.
//

import Foundation
import SwiftUI

class RideScooterViewModel: ObservableObject {
    @Published var tripDetailsSheetMode = SheetDisplayMode.half
    @Published var scooterData: ScooterData
    var mapViewModel: ScooterMapViewModel = .init()
    @Published var mapCenterAddress: String? = nil

    init(scooterData: ScooterData) {
        self.scooterData = scooterData
        
        mapViewModel.onMapRegionChanged = { mapCenterAddress in
            withAnimation {
                self.mapCenterAddress = mapCenterAddress
            }
        }
    }
    
    
    func centerMapOnUserLocation() {
        mapViewModel.centerMapOnUserLocation()
    }
}
