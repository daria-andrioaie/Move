//
//  FindScootersViewModel.swift
//  Move
//
//  Created by Daria Andrioaie on 13.09.2022.
//

import Foundation
import SwiftUI
import MapKit

class FindScootersViewModel: ObservableObject {
    var selectedScooter: SelectedScooterViewModel
    @Published var unlockOptionsSheetDisplayMode = SheetDisplayMode.none
    var mapViewModel: ScooterMapViewModel = .init()
    
    init(selectedScooter: SelectedScooterViewModel) {
        print("find scooters view model instantiated")
        self.selectedScooter = selectedScooter
        mapViewModel.onSelectedScooter = { scooter in
            withAnimation {
                self.selectedScooter.value = scooter
            }
        }
        mapViewModel.onDeselectedScooter = {
            withAnimation {
                self.selectedScooter.value = nil
                self.unlockOptionsSheetDisplayMode = SheetDisplayMode.none
            }
        }
        
        if let unlockedScooter = self.selectedScooter.value {
            if unlockedScooter.scooterData.lockedStatus == .unlocked {
                mapViewModel.mapView.addAnnotation(unlockedScooter as MKAnnotation)
                mapViewModel.mapView.setRegion(.init(center: unlockedScooter.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)
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
