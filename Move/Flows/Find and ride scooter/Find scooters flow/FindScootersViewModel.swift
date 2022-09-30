//
//  FindScootersViewModel.swift
//  Move
//
//  Created by Daria Andrioaie on 13.09.2022.
//

import Foundation
import SwiftUI

class FindScootersViewModel: ObservableObject {
    @Binding var selectedScooterAnnotation: ScooterAnnotation? {
        willSet {
            objectWillChange.send()
        }
    }
    @Published var startRideSheetDisplayMode = SheetDisplayMode.none

    @Published var unlockOptionsSheetDisplayMode = SheetDisplayMode.none
    var mapViewModel: ScooterMapViewModel = .init()
    
    init(selectedScooterAnnotation: Binding<ScooterAnnotation?>) {
        self._selectedScooterAnnotation = selectedScooterAnnotation
        mapViewModel.onSelectedScooter = { scooter in
            withAnimation {
                self.selectedScooterAnnotation = scooter
            }
        }
        mapViewModel.onDeselectedScooter = {
            withAnimation {
                self.selectedScooterAnnotation = nil
                self.unlockOptionsSheetDisplayMode = SheetDisplayMode.none
            }
        }
    }
    
    func centerMapOnUserLocation() {
        mapViewModel.centerMapOnUserLocation()
    }
    
    func loadScooters() {
        mapViewModel.getAllScooters()
    }
    
    func refreshScootersEvery30Seconds() {
        _ = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            print("refreshed scooters")
            self.mapViewModel.getAllScooters()
        }
    }
}
