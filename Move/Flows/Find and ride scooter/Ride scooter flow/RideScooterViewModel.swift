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

    init(scooterData: ScooterData) {
        self.scooterData = scooterData
    }
    
    var mapViewModel: ScooterMapViewModel = .init()

    func centerMapOnUserLocation() {
        mapViewModel.centerMapOnUserLocation()
    }
}
