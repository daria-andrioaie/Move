//
//  ScooterAnnotation.swift
//  Move
//
//  Created by Daria Andrioaie on 07.09.2022.
//

import Foundation
import MapKit

class ScooterAnnotation: NSObject, MKAnnotation {
    let scooterData: ScooterData
    var coordinate: CLLocationCoordinate2D
    
    init(scooterData: ScooterData, coordinate: CLLocationCoordinate2D) {
        self.scooterData = scooterData
        self.coordinate = coordinate
    }
    
    func getScooterData() -> ScooterData {
        self.scooterData
    }
    
    static func requestMockData() -> [ScooterAnnotation] {
        return [
            ScooterAnnotation(scooterData: .mockedScooter(), coordinate: .init(latitude: 46.771541, longitude: 23.625207)),
            ScooterAnnotation(scooterData: .init(_id: "ddwsx", scooterNumber: 1237, bookStatus: "free", lockStatus: "unlocked", battery: 87, location: .init(coordinates: [46.775831, 23.604520], address: nil)), coordinate: .init(latitude: 46.775831, longitude: 23.604520))
        ]
    }
}
