//
//  ScooterMapView.swift
//  Move
//
//  Created by Daria Andrioaie on 07.09.2022.
//

import SwiftUI
import MapKit

class ScooterMapViewModel: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
    
//    override init() {
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.distanceFilter = kCLDistanceFilterNone
//        locationManager.startUpdatingLocation()
//    }
    
    var scooters: [ScooterAnnotation] = [] {
        didSet {
            refreshScooterList()
        }
    }
    
    var onSelectedScooter: (ScooterAnnotation) -> Void = { _ in }
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.mapType = .mutedStandard
        mapView.setRegion(MKCoordinateRegion(center: .init(latitude: 46.753455, longitude: 23.584404), latitudinalMeters: 500, longitudinalMeters: 500), animated: true)
        
        mapView.showAnnotations(mapView.annotations, animated: true)
        mapView.showsUserLocation = true
        mapView.delegate = self
        return mapView
    }()
    
    func refreshScooterList() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(scooters)
    }
}

extension ScooterMapViewModel: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customView")
        
        if annotation is MKUserLocation {
            let userCenteredRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(userCenteredRegion, animated: true)
            return nil
        }
        
        // some more code
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // when selecting userLocationAnnotation
        
        // when selecting a scooter annotation
    }
}

struct ScooterMapView: UIViewRepresentable {
    let viewModel: ScooterMapViewModel
    
    func makeUIView(context: Context) -> MKMapView {
        return viewModel.mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {

    }
}
