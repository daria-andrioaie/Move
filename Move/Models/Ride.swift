//
//  Ride.swift
//  Move
//
//  Created by Daria Andrioaie on 14.09.2022.
//

import Foundation

enum StartRideType: String, Codable {
    case PIN
    case QR
    case NFC
}

enum RideStatus: String, Codable {
    case completed
    case inProgress = "in progress"
}

class Ride: Codable, Hashable {
    static func == (lhs: Ride, rhs: Ride) -> Bool {
        lhs._id == rhs._id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
    }
    
    let _id: String
    let scooterNumber: Int
    let startMode: StartRideType
    let userId: String
    let source: String?
    let destination: String?
    let duration: Int
    let distance: Int
    let price: Int
    let status: RideStatus
    
    
    required init(_id: String, scooterNumber: Int, startMode: String, userId: String, source: String, destination: String, duration: Int, distance: Int, price: Int, status: String) {
        self._id = _id
        self.scooterNumber = scooterNumber
        self.startMode = StartRideType(rawValue: startMode) ?? .PIN
        self.userId = userId
        self.source = source
        self.destination = destination
        self.duration = duration
        self.distance = distance
        self.price = price
        self.status = RideStatus(rawValue: status) ?? .inProgress
    }
}
