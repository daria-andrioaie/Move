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
    @Published var rideData: Ride? = nil
    @Published var scooterData: ScooterData? = nil
    @Published var timeElapsed: Int = 0
    
    @Published var distanceCovered: Int = 0
    @Published var mapCenterAddress: String? = nil
    
    @Published var metricsTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var locationUpdateTimer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    var mapViewModel: ScooterMapViewModel = .init()
    let scootersService = ScootersAPIService()
    let ridesService = RidesAPIService()
    let errorHandler = SwiftMessagesErrorHandler()
    

    init() {
        print("ride scooter view model instantiated")
        do {
            let ride = try UserDefaultsService().getRide()
            RideScooterViewModel.getRideById(rideId: ride._id) { returnedRide in
                self.rideData = returnedRide
                self.timeElapsed = self.getElapsedSecondsFromTheStartOfTheRide()
                self.distanceCovered = self.rideData?.distance ?? 0
            }
            RideScooterViewModel.getScooterByNumber(scooterNumber: ride.scooterNumber, onRequestCompleted: { returnedScooter in
                self.scooterData = returnedScooter
            })
            
        }
        catch {
            rideData = nil
            scooterData = nil
            print("unexpected error occured")
        }
        
        mapViewModel.onMapRegionChanged = { mapCenterAddress in
            withAnimation {
                self.mapCenterAddress = mapCenterAddress
            }
        }
    }
    
    func getElapsedSecondsFromTheStartOfTheRide() -> Int {
        let timeInterval = Date(milliseconds: Int64(rideData?.startTime ?? 0)).timeIntervalSinceNow
        return -Int(timeInterval.rounded())
    }
    
    func startUpdatingElapsedTime() {
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.timeElapsed = self.getElapsedSecondsFromTheStartOfTheRide()
        }
    }

    func startUpdatingCoveredDistance() {
        _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            self.distanceCovered += 20
        }
    }
    
    func updateTimeLocally() {
        self.timeElapsed = self.getElapsedSecondsFromTheStartOfTheRide()
    }
    
    func updateDistanceLocallyIfScooterIsUnlocked() {
        guard let lockedStatus = self.scooterData?.lockedStatus else {
            return
        }
        if lockedStatus == .unlocked {
            self.distanceCovered += 10
        }
    }
    
    func stopTimers() {
        self.metricsTimer.upstream.connect().cancel()
        self.locationUpdateTimer.upstream.connect().cancel()
    }
    
    func startSendingLocationUpdates() {
        _ = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            
            self.sendLocationUpdates()
        }
    }
    
    func toggleLockStatusOfScooter() {
        guard let scooterData = scooterData else {
            return
        }

        switch scooterData.lockedStatus {
        case .locked:
            scootersService.changeLockStatus(scooterNumber: String(scooterData.scooterNumber), newLockStatus: .unlocked) { result in
                switch result {
                case .success(let scooter):
                    self.scooterData = scooter
                    print("unlocked scooter")
                case .failure(let error):
                    self.errorHandler.handle(message: error.message)
                }
            }
            
        case .unlocked:
            scootersService.changeLockStatus(scooterNumber: String(scooterData.scooterNumber), newLockStatus: .locked) { result in
                switch result {
                case .success(let scooter):
                    self.scooterData = scooter
                    print("locked scooter")
                case .failure(let error):
                    self.errorHandler.handle(message: error.message)
                }
            }
        }
    }
    
    func sendLocationUpdates() {
        guard let userLocation = mapViewModel.userLocation else {
            self.errorHandler.handle(message: "Cannot update ride without access to your location")
            return
        }
        
        let userLocationLatitude = userLocation.coordinate.latitude
        let userLocationLongitude = userLocation.coordinate.longitude
        
        let updateRideParameters = ["longitude": userLocationLongitude, "latitude": userLocationLatitude] as [String: Any]
        self.ridesService.updateRide(updateRideParameters: updateRideParameters) { result in
            switch result {
            case .success(let ride):
                print("updated ride. new distance is \(ride.distance)")
                self.distanceCovered = ride.distance
                try? UserDefaultsService().saveRide(ride)
            case .failure(let error):
                self.errorHandler.handle(message: error.message)
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
        guard let rideData = rideData else {
            return
        }
        
        guard let scooterData = scooterData else {
            return
        }

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

            self.ridesService.endRide(rideId: rideData._id, endRideParameters: endRideParameters) { result in
                switch result {
                case .success(let ride):
                    print("ended ride with id : \(ride._id)")
                    // save current ride to user defaults
                    try? UserDefaultsService().saveRide(ride)
                    if scooterData.lockedStatus == .unlocked {
                        self.toggleLockStatusOfScooter()
                    }
                    print("final distance of ride is \(ride.distance)")
                    self.ridesService.updateCurrentUserInUserDefaults()
                    self.stopTimers()
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
