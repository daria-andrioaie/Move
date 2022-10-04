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
    @Published var rideData: Ride = Ride.mockedRide()
    @Published var scooterData: ScooterData = ScooterData.mockedScooter()
    @Published var timeElapsed: Int = 0
    
    @Published var distanceCovered: Int = 0
    @Published var mapCenterAddress: String? = nil
    var mapViewModel: ScooterMapViewModel = .init()
    let scootersService = ScootersAPIService()
    let ridesService = RidesAPIService()

    init() {
        print("ride scooter view model instantiated")
        do {
            let ride = try UserDefaultsService().getRide()
            RideScooterViewModel.getRideById(rideId: ride._id) { returnedRide in
                self.rideData = returnedRide
            }
            RideScooterViewModel.getScooterByNumber(scooterNumber: ride.scooterNumber, onRequestCompleted: { returnedScooter in
                self.scooterData = returnedScooter
            })
        }
        catch {
            rideData = Ride.mockedRide()
            scooterData = ScooterData.mockedScooter()
            print("unexpected error occured")
        }
        
        self.timeElapsed = getElapsedSecondsFromTheStartOfTheRide()
        self.distanceCovered = rideData.distance
        
        mapViewModel.onMapRegionChanged = { mapCenterAddress in
            withAnimation {
                self.mapCenterAddress = mapCenterAddress
            }
        }
    }
    
    func getElapsedSecondsFromTheStartOfTheRide() -> Int {
        let timeInterval = Date(milliseconds: Int64(rideData.startTime)).timeIntervalSinceNow
        return -Int(timeInterval.rounded())
    }
    
    func startUpdatingElapsedTime() {
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.timeElapsed = self.getElapsedSecondsFromTheStartOfTheRide()
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
    
    static func getRideById(rideId: String, onRequestCompleted: @escaping (Ride) -> Void) {
        RidesAPIService().getRideById(rideId: rideId) { result in
            switch result {
            case .success(let ride):
                onRequestCompleted(ride)
            case .failure(let error):
                SwiftMessagesErrorHandler().handle(message: error.message)
                onRequestCompleted(Ride.mockedRide())
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
            let endRideParameters = ["longitude": userLocationLongitude, "latitude": userLocationLatitude, "endAddress": address] as [String: Any]

            self.ridesService.endRide(rideId: self.rideData._id, endRideParameters: endRideParameters) { result in
                switch result {
                case .success(let ride):
                    print("ended ride with id : \(ride._id)")
                    // save current ride to user defaults
                    try? UserDefaultsService().saveRide(ride)
                    if self.scooterData.lockedStatus == .unlocked {
                        self.toggleLockStatusOfScooter()
                    }
                    self.ridesService.updateCurrentUserInUserDefaults()
                    onRequestCompleted(.success(ride))
                case .failure(let error):
                    onRequestCompleted(.failure(APIError(message: error.message)))
                }
            }
        })
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
