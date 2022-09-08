//
//  ScooterAnnotation.swift
//  Move
//
//  Created by Daria Andrioaie on 07.09.2022.
//

import Foundation
import MapKit

class ScooterAnnotation: NSObject, MKAnnotation {
    let title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
    
    static func requestMockData() -> [ScooterAnnotation] {
        return [
            ScooterAnnotation(title: "Iulius Mall", coordinate: .init(latitude: 46.771541, longitude: 23.625207)),
            ScooterAnnotation(title: "The office", coordinate: .init(latitude: 46.775831, longitude: 23.604520)),
            ScooterAnnotation(title: "Cinema", coordinate: .init(latitude: 46.770349, longitude: 23.595509))
        ]
    }
}
