//
//  Scooter.swift
//  Move
//
//  Created by Daria Andrioaie on 08.09.2022.
//

import Foundation

class Location: Codable {
    var coordinates: [Double]
    var address: String
    
    required init(coordinates: [Double], address: String) {
        self.coordinates = coordinates
        self.address = address
    }
}

class ScooterData: Codable {
    var _id: String
    var scooterNumber: Int
    var bookedStatus: String
    var lockedStatus: String
    var battery: Int
    var location: Location
    
    required init(_id: String, scooterNumber: Int, bookedStatus: String, lockedStatus: String, battery: Int, location: Location) {
        self._id = _id
        self.scooterNumber = scooterNumber
        self.bookedStatus = bookedStatus
        self.lockedStatus = lockedStatus
        self.battery = battery
        self.location = location
    }
}
