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
    @Published var mapCenterAddress: String? = nil
    @Published var unlockOptionsSheetDisplayMode = SheetDisplayMode.none
    var mapViewModel: ScooterMapViewModel = .init()
    
    init(selectedScooter: SelectedScooterViewModel) {
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
        
        mapViewModel.onMapRegionChanged = { mapCenterAddress in
            withAnimation {
                self.mapCenterAddress = mapCenterAddress
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
    
    func lockUnlockedScooter() {
        if self.selectedScooter.value == nil {
            return
        }
        
        self.selectedScooter.value?.scooterData.lockedStatus = .locked
        guard let selectedScooterData = self.selectedScooter.value?.scooterData else {
            return
        }
        
        let scootersService = ScootersAPIService()
        scootersService.changeLockStatus(scooterNumber: String(selectedScooterData.scooterNumber), newLockStatus: .locked) { result in
            switch result {
            case .success(_):
                print("locked scooter")
            case .failure(let error):
                print("\(error.message)")
            }
        }
        self.selectedScooter.value = nil
    }
    
    func startRideOnCurrentUnlockedScooter(onRequestCompleted: @escaping (Result<Ride, APIError>) -> Void) {
        if self.selectedScooter.value == nil {
            onRequestCompleted(.failure(APIError(message: "Cannot start ride without a scooter currently selected")))
            return
        }
        
        guard let userLocation = mapViewModel.userLocation else {
            onRequestCompleted(.failure(APIError(message: "Cannot start ride without access to user location")))
            return
        }
        
        self.selectedScooter.value?.scooterData.bookedStatus = .booked
        let scooterNumber = self.selectedScooter.value!.scooterData.scooterNumber
        
        let ridesService = RidesAPIService()
        
        //TODO: here there should be the user location instead of the hardcoded values
        let address = mapViewModel.getAddressBasedOnCoordinates(latitude: 46.753302, longitude: 23.584109)
        let startRideParameters = ["longitude": 23.584109, "latitude": 46.753302, "scooterNumber": scooterNumber, "startMode": "PIN", "startAddress": address] as [String: Any]
        
        ridesService.startRide(startRideParameters: startRideParameters) { result in
            switch result {
            case .success(let ride):
                // save current ride to user defaults
                try? UserDefaultsService().saveRide(ride)
                onRequestCompleted(.success(ride))
            case .failure(let error):
                onRequestCompleted(.failure(APIError(message: error.message)))
            }
        }
    }
    
    func refreshScootersEvery30Seconds() {
        _ = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            self.mapViewModel.getAllScooters()
        }
    }
}
