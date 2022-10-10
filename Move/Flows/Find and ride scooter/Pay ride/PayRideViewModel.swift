//
//  PayRideViewModel.swift
//  Move
//
//  Created by Daria Andrioaie on 10.10.2022.
//

import Foundation
import SwiftUI
import MapKit

class PayRideViewModel: ObservableObject {
    var mapViewModel: ScooterMapViewModel = .init()
    @Published var rideData: Ride
    @Published var paymentSuccessfulAlertIsShowing: Bool = false

    init() {
        mapViewModel.mapView.removeAnnotations(mapViewModel.mapView.annotations)
        do {
            let ride = try UserDefaultsService().getRide()
            self.rideData = ride
        }
        catch {
            rideData = Ride.mockedRide()
            print("unexpected error occured")
        }
    }
    
    func removeRideFromUserDefaults() {
        UserDefaultsService().removeCurrentRide()
    }
    
    func getSnapshotOfRide() -> UIImage {
        addRouteAsOverlayOnMap()
        let snapshotOptions: MKMapSnapshotter.Options = .init()
        snapshotOptions.region = mapViewModel.mapView.region
        snapshotOptions.size = CGSize(width: 100, height: 100)
        snapshotOptions.mapType = .mutedStandard
        let snapshotter = MKMapSnapshotter(options: snapshotOptions)
        
        var imageView = UIImage()
    
        
        snapshotter.start { snapshot, error in
            if let snapshot = snapshot {
                imageView = snapshot.image
            }
        }
        
        return imageView
    }
    
    func addRouteAsOverlayOnMap() {
        let coordinates: [CLLocationCoordinate2D] = [.init(latitude: 46.754438, longitude: 23.584173), .init(latitude: 46.755232, longitude: 23.588733), .init(latitude: 46.757408, longitude: 23.588132), .init(latitude: 46.757834, longitude: 23.589580)]
        let polyline = MKPolyline(coordinates: coordinates, count: 4)
        
        let surroundingRectangle = polyline.boundingMapRect
        
        mapViewModel.mapView.addOverlay(polyline)
        mapViewModel.mapView.setRegion(.init(surroundingRectangle), animated: false)
    }
    
    
}
