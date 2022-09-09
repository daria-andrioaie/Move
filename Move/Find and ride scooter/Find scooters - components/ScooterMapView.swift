//
//  ScooterMapView.swift
//  Move
//
//  Created by Daria Andrioaie on 07.09.2022.
//

import SwiftUI
import MapKit

class ScooterMapViewModel: NSObject, ObservableObject {
    
    private var userLocation: CLLocation?
    private var locationManager = CLLocationManager()
    
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
    }
    
    override init() {
        super.init()
        configureLocationManager()
    }
    
    var scooters: [ScooterAnnotation] = [] {
        didSet {
            refreshScooterList()
        }
    }
    
    var onSelectedScooter: (ScooterAnnotation) -> Void = { _ in }
    var onDeselectedScooter: () -> Void = {}
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.mapType = .mutedStandard
        mapView.setRegion(MKCoordinateRegion.ClujCentralRegion(), animated: true)
        
        mapView.showAnnotations(mapView.annotations, animated: true)
        mapView.showsUserLocation = true
        mapView.delegate = self
        return mapView
    }()
    
    func refreshScooterList() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(scooters)
    }
    
    func centerMapOnUserLocation() {
        guard let userLocation = self.userLocation else {
            return
        }
        
        mapView.setRegion(MKCoordinateRegion.userCenteredRegion(userCoordinates: userLocation.coordinate), animated: true)
    }
    
    func centerMapOnClujCityCenter() {
        mapView.setRegion(MKCoordinateRegion.ClujCentralRegion(), animated: true)
    }
    
    func getAllScooters() {
        let service = ScootersAPIService()
        service.getScootersInArea(center: mapView.centerCoordinate, radius: 4000) { result in
            switch result {
            case .success(let scooters):
                self.scooters = scooters.getAnnotations()
            case .failure(let error):
                print("\(error.message)")
            }
        }
    }
}

extension ScooterMapViewModel: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customView")
        annotationView.image = UIImage(named: "scooter-location-pin-purple")
        //TODO: reuse annotations
        
        if annotation is MKUserLocation {
            self.centerMapOnUserLocation()
            return nil
        }
        
        // some more code
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // when selecting userLocationAnnotation
        if view.annotation is MKUserLocation {
            centerMapOnUserLocation()
            return
        }
        
        // when selecting a scooter annotation
        if let scooterAnnotation = view.annotation as? ScooterAnnotation {
            self.onSelectedScooter(scooterAnnotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.onDeselectedScooter()
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        getAllScooters()
    }
}

extension ScooterMapViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            return
        }
        DispatchQueue.main.async {
            self.userLocation = lastLocation
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            //TODO: show an alert
            centerMapOnClujCityCenter()
            print("Location is restricted")
        case .denied:
            //TODO: show an alert
            centerMapOnClujCityCenter()
            print("Location is denied. go to settings")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
            self.centerMapOnUserLocation()
            break
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

extension MKCoordinateRegion {
    static func ClujCentralRegion() -> MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.769484, longitude: 23.589884), latitudinalMeters: 4000, longitudinalMeters: 4000)
    }
    static func userCenteredRegion(userCoordinates: CLLocationCoordinate2D) -> MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userCoordinates.latitude, longitude: userCoordinates.longitude), latitudinalMeters: 4000, longitudinalMeters: 4000)
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
