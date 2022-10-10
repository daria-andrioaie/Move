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
    @Published var routeImage: UIImage? = nil
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
        getSnapshotOfRide { snapshotImage in
            self.routeImage = snapshotImage
        }
        
    }
    
    func removeRideFromUserDefaults() {
        UserDefaultsService().removeCurrentRide()
    }
    
    //TODO: compute the region based on the coordinates
    
    func getSnapshotOfRide(onSnapshotFinished: @escaping (UIImage) -> Void) {
//        addRouteAsOverlayOnMap()
        let snapshotOptions: MKMapSnapshotter.Options = .init()
//        snapshotOptions.region = mapViewModel.mapView.region
        snapshotOptions.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.755232, longitude: 23.588733), latitudinalMeters: 1000, longitudinalMeters: 1000)
        snapshotOptions.scale = UIScreen.main.scale
        snapshotOptions.size = CGSize(width: 330, height: 220)
        snapshotOptions.mapType = .mutedStandard
        let snapshotter = MKMapSnapshotter(options: snapshotOptions)
        
        snapshotter.start { snapshot, error in
            if let snapshot = snapshot {
                let image = self.drawLineOnImage(snapshot: snapshot)
                onSnapshotFinished(image)
            }
        }
    }
    
    func drawLineOnImage(snapshot: MKMapSnapshotter.Snapshot) -> UIImage {
        let coordinates: [CLLocationCoordinate2D] = [.init(latitude: 46.767348, longitude: 23.569120), .init(latitude: 46.755232, longitude: 23.588733), .init(latitude: 46.757408, longitude: 23.588132), .init(latitude: 46.757834, longitude: 23.589580)]
        
        let image = snapshot.image
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 330, height: 251), true, 0)
        
        image.draw(at: CGPoint.zero)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setLineWidth(2)
        context!.setStrokeColor(CGColor(red: 229/255, green: 48/255, blue: 98/255, alpha: 1))
        
        context!.move(to: snapshot.point(for: coordinates[0]))
        for i in 0..<coordinates.count {
            context!.addLine(to: snapshot.point(for: coordinates[i]))
            context!.move(to: snapshot.point(for: coordinates[i]))
        }
        
        context!.strokePath()
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resultImage!
    }
    
//    func addRouteAsOverlayOnMap() {
//        let coordinates: [CLLocationCoordinate2D] = [.init(latitude: 37.33459999999999, longitude: -122.00919999999999), .init(latitude: 46.755232, longitude: 23.588733), .init(latitude: 46.757408, longitude: 23.588132), .init(latitude: 46.757834, longitude: 23.589580)]
//        let polyline = MKPolyline(coordinates: coordinates, count: 4)
//
//        let surroundingRectangle = polyline.boundingMapRect
//
//        mapViewModel.mapView.addOverlay(polyline)
////        mapViewModel.centerMapOnUserLocation()
//        mapViewModel.mapView.setRegion(.init(surroundingRectangle), animated: false)
//    }
    
    
}
