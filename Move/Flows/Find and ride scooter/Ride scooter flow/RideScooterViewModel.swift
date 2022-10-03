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
    @Published var rideData: Ride
    @Published var scooterData: ScooterData = ScooterData.mockedScooter()
    @Published var timeElapsed: Int
    @Published var distanceCovered: Int
    @Published var mapCenterAddress: String? = nil
    var mapViewModel: ScooterMapViewModel = .init()
    let scootersService = ScootersAPIService()
    let ridesService = RidesAPIService()

    init() {
        print("ride scooter view model instantiated")
        self.timeElapsed = 0
        self.distanceCovered = 0
        do {
            let ride = try UserDefaultsService().getRide()
            self.rideData = ride
            RideScooterViewModel.getScooterByNumber(scooterNumber: ride.scooterNumber, onRequestCompleted: { returnedScooter in
                self.scooterData = returnedScooter
            })
        }
        catch {
            rideData = Ride.mockedRide()
            scooterData = ScooterData.mockedScooter()
            print("unexpected error occured")
        }
        mapViewModel.onMapRegionChanged = { mapCenterAddress in
            withAnimation {
                self.mapCenterAddress = mapCenterAddress
            }
        }
    }
    
    func startUpdatingElapsedTime() {
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.scooterData.lockedStatus == .unlocked {
                self.timeElapsed = self.timeElapsed + 1
            }
        }
    }

    func startUpdatingCoveredDistance() {
        _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            if self.scooterData.lockedStatus == .unlocked {
                self.distanceCovered += 100
            }
        }
    }
    
    func toggleLockStatusOfScooter() {
        switch scooterData.lockedStatus {
        case .locked:
            scootersService.changeLockStatus(scooterNumber: String(scooterData.scooterNumber), newLockStatus: .unlocked) { result in
                switch result {
                case .success(let scooter):
                    self.scooterData = scooter
                    print("unlocked scooter")
                case .failure(let error):
                    SwiftMessagesErrorHandler().handle(message: error.message)
                }
            }
            
        case .unlocked:
            scootersService.changeLockStatus(scooterNumber: String(scooterData.scooterNumber), newLockStatus: .locked) { result in
                switch result {
                case .success(let scooter):
                    self.scooterData = scooter
                    print("locked scooter")
                case .failure(let error):
                    SwiftMessagesErrorHandler().handle(message: error.message)
                }
            }
        }
    }
    
    func endRide(onRequestCompleted: @escaping (Result<Ride, APIError>) -> Void) {
        guard let userLocation = mapViewModel.userLocation else {
            onRequestCompleted(.failure(APIError(message: "Cannot end ride without access to user location")))
            return
        }
        
        let userLocationLatitude = userLocation.coordinate.latitude
        let userLocationLongitude = userLocation.coordinate.longitude

        var address = "dummy address"
        mapViewModel.getAddressBasedOnCoordinates(latitude: userLocationLatitude, longitude: userLocationLongitude, onRequestCompleted: { detectedAddress in
            address = detectedAddress
        })
        let endRideParameters = ["longitude": userLocationLongitude, "latitude": userLocationLatitude, "endAddress": address] as [String: Any]

        ridesService.endRide(rideId: self.rideData._id, endRideParameters: endRideParameters) { result in
            switch result {
            case .success(let ride):
                print("ended ride with id : \(ride._id)")
                // save current ride to user defaults
                try? UserDefaultsService().saveRide(ride)
                if self.scooterData.lockedStatus == .unlocked {
                    self.toggleLockStatusOfScooter()
                }
                onRequestCompleted(.success(ride))
            case .failure(let error):
                onRequestCompleted(.failure(APIError(message: error.message)))
            }
        }
    }
    
    static func getScooterByNumber(scooterNumber: Int, onRequestCompleted: @escaping (ScooterData) -> Void){
        ScootersAPIService().getScooterByNumber(scooterNumber: String(scooterNumber)) { result in
            switch result {
            case .success(let scooter):
                onRequestCompleted(scooter)
            case .failure(let error):
                SwiftMessagesErrorHandler().handle(message: error.message)
                onRequestCompleted(ScooterData.mockedScooter())
            }
        }
    }
    
    func centerMapOnUserLocation() {
        mapViewModel.centerMapOnUserLocation()
    }
}
