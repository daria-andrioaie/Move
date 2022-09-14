//
//  Ride.swift
//  Move
//
//  Created by Daria Andrioaie on 14.09.2022.
//

import Foundation

class Ride: Identifiable {
    public typealias ID = Int
    
    let id: ID
    let source: String
    let destination: String
    let travelTimeInSeconds: Int
    let distanceInKilometers: Double
    
    init(id: ID, source: String, destination: String, travelTimeInSeconds: Int, distanceInKilometers: Double) {
        self.id = id
        self.source = source
        self.destination = destination
        self.travelTimeInSeconds = travelTimeInSeconds
        self.distanceInKilometers = distanceInKilometers
    }
}
