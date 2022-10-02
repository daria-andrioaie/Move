//
//  Scooter.swift
//  Move
//
//  Created by Daria Andrioaie on 08.09.2022.
//

import Foundation
import MapKit

class Location: Codable {
    var coordinates: [Double]
    var address: String?
    
    required init(coordinates: [Double], address: String?) {
        self.coordinates = coordinates
        self.address = address
    }
}

enum LockStatus: String, Codable {
    case locked
    case unlocked
}

enum BookStatus: String, Codable {
    case free
    case booked
}

class ScooterData: Codable {
    var _id: String
//    var internalId: String
    var scooterNumber: Int
    var bookedStatus: BookStatus
    var lockedStatus: LockStatus
    var battery: Int
//    var chargingStatus: String
    var location: Location
    
    required init(_id: String, scooterNumber: Int, bookedStatus: String, lockedStatus: String, battery: Int, location: Location) {
        self._id = _id
        self.scooterNumber = scooterNumber
        self.bookedStatus = .init(rawValue: bookedStatus) ?? .free
        self.lockedStatus = .init(rawValue: lockedStatus) ?? .locked
        self.battery = battery
        self.location = location
    }
    
    func toString() -> String {
        return "\(scooterNumber)" + " " + bookedStatus.rawValue + " " + lockedStatus.rawValue + "\n"
    }
    
    func computeAddressBasedOnLocationCoordinates() -> String {
        CLGeocoder().reverseGeocodeLocation(.init(latitude: self.location.coordinates[1], longitude: self.location.coordinates[0])) { placemarks, error in
            if let error = error {
                print("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if let placemarks = placemarks {
                if placemarks.count > 0 {
                    let scooterPlacemark = placemarks[0] as CLPlacemark
                    
                    if let streetName = scooterPlacemark.thoroughfare {
                        var addressOfScooter = streetName
                        if let streetNumber = scooterPlacemark.subLocality {
                            addressOfScooter += ", \(streetNumber)"
                        }
                        self.location.address = addressOfScooter
                    }
                } else {
                    print("Problem with the data received from geocoder")
                }
            }
        }
        if let scooterAddress = self.location.address {
            return scooterAddress
        }
        return "no address detected"
    }
    
    static func mock_getScootersNearTapp() -> [ScooterData] {
        return [
            ScooterData(_id: "scooter1", scooterNumber: 1, bookedStatus: "dummy", lockedStatus: "dummy", battery: 98, location: .init(coordinates: [46.753108, 23.579225], address: nil)),
            ScooterData(_id: "scooter2", scooterNumber: 1, bookedStatus: "dummy", lockedStatus: "dummy", battery: 98, location: .init(coordinates: [46.754675, 23.575134], address: nil)),
            ScooterData(_id: "scooter3", scooterNumber: 1, bookedStatus: "dummy", lockedStatus: "dummy", battery: 98, location: .init(coordinates: [46.752570, 23.580858], address: nil))
        ]
    }
    
    static func mockedScooter() -> ScooterData {
        return .init(_id: "alaal", scooterNumber: 1234, bookedStatus: "free", lockedStatus: "locked", battery: 100, location: .init(coordinates: [23.123456, 46.123456], address: "Strada Avram Iancu nr .26 Cladirea 2"))
    }
}

extension Array where Element == ScooterData {
    func getAnnotations() -> [ScooterAnnotation] {
        self.map { scooter in
            ScooterAnnotation(scooterData: scooter, coordinate: .init(latitude: scooter.location.coordinates[1], longitude: scooter.location.coordinates[0]))
        }
    }
}
