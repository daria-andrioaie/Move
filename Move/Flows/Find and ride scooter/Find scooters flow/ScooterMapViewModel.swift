//
//  ScooterMapViewModel.swift
//  Move
//
//  Created by Daria Andrioaie on 13.09.2022.
//

import Foundation
import MapKit

class ScooterMapViewModel: NSObject, ObservableObject {
    
    private var userLocation: CLLocation?
    private var locationManager = CLLocationManager()
    
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
//        locationManager.startUpdatingLocation()
    }
    
    override init() {
        super.init()
        configureLocationManager()
    }
    
    var scooters: [ScooterAnnotation] = [] {
        didSet {
            refreshScooterList()
            
            //TODO: is this okay for running functions repeatedly or is it better to use a timer?
            //TODO: if a scooter card view is shown while refreshing the scooters, it will disappear
//            DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
//                print("refreshed scooters")
//                self.getAllScooters()
//            }
        }
    }
    
    var onSelectedScooter: (ScooterAnnotation) -> Void = { _ in }
    var onDeselectedScooter: () -> Void = {}
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.mapType = .mutedStandard
        mapView.setRegion(MKCoordinateRegion.AdamHome(), animated: true)

//        mapView.setRegion(MKCoordinateRegion.ClujCentralRegion(), animated: true)
        
        mapView.showAnnotations(mapView.annotations, animated: true)
        mapView.showsUserLocation = true
        mapView.delegate = self
        return mapView
    }()
    
    func refreshScooterList() {
        // if one scooter is selected and it's card view is displayed
        if mapView.selectedAnnotations.count >= 1{
            if let selectedScooter = mapView.selectedAnnotations[0] as? ScooterAnnotation {
                mapView.removeAnnotations(mapView.annotations)
                mapView.addAnnotations(scooters)
                
//                mapView.addAnnotation(selectedScooter)
//                mapView(self.mapView, didSelect: <#T##MKAnnotationView#>)
                
                onSelectedScooter(selectedScooter)
            }
            else if let selectedCluster = mapView.selectedAnnotations[0] as? MKClusterAnnotation {
                mapView.removeAnnotations(mapView.annotations)
                mapView.addAnnotations(scooters)
                let memberScooterAnnotations = selectedCluster.memberAnnotations as! [ScooterAnnotation]
                onSelectedScooter(memberScooterAnnotations[0])
            }
        }
        else {
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(scooters)
        }
    }
    
    func centerMapOnUserLocation() {
        guard let userLocation = self.userLocation else {
            return
        }
        
        mapView.setRegion(MKCoordinateRegion.userCenteredRegion(userCoordinates: userLocation.coordinate), animated: true)
    }
    
    func centerMapOnClujCityCenter() {
        mapView.setRegion(MKCoordinateRegion.AdamHome(), animated: true)
//        mapView.setRegion(MKCoordinateRegion.ClujCentralRegion(), animated: true)
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
        
//        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "scooterAnnotationView") ?? MKAnnotationView(annotation: annotation, reuseIdentifier: "scooterAnnotationView")
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "scooterAnnotationView")

        
        if annotation is MKUserLocation {
            //TODO: add a custom view to the user location annotation, as in figma
            annotationView.image = UIImage(named: "navigation-fill-blue")
            return annotationView
        }
  
        annotationView.clusteringIdentifier = "scootersCluster"
        annotationView.image = UIImage(named: "scooter-location-pin-purple")
        if let clusterAnnotation = annotation as? MKClusterAnnotation {
            let scootersCount = clusterAnnotation.memberAnnotations.count
            if scootersCount > 1 {
                let countLabel = UILabel()
                annotationView.addSubview(countLabel)
                countLabel.text = String(scootersCount)
                countLabel.font = UIFont(name: "BaiJamjuree-Medium", size: 12)
                countLabel.translatesAutoresizingMaskIntoConstraints = false
                countLabel.adjustsFontSizeToFitWidth = true
                NSLayoutConstraint.activate([
                    countLabel.centerXAnchor.constraint(equalTo: annotationView.centerXAnchor, constant: 0.5),
                    countLabel.centerYAnchor.constraint(equalTo: annotationView.centerYAnchor, constant: -3.5),
                    countLabel.widthAnchor.constraint(equalTo: annotationView.widthAnchor, multiplier: 0.3),
                    countLabel.heightAnchor.constraint(equalTo: annotationView.heightAnchor, multiplier: 0.4)
                ])
            }
        }
        return annotationView

    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // when selecting userLocationAnnotation
        if view.annotation is MKUserLocation {
            centerMapOnUserLocation()
            return
        }
        view.image = UIImage(named: "scooter-location-pin-pink")
        
        // when selecting a scooter annotation
        if let scooterAnnotation = view.annotation as? ScooterAnnotation {
            self.onSelectedScooter(scooterAnnotation)
        }
        
        if let clusterAnnotation = view.annotation as? MKClusterAnnotation {
            let memberScooterAnnotations = clusterAnnotation.memberAnnotations as! [ScooterAnnotation]
            self.onSelectedScooter(memberScooterAnnotations[0])
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.annotation is ScooterAnnotation || view.annotation is MKClusterAnnotation {
            view.image = UIImage(named: "scooter-location-pin-purple")
            self.onDeselectedScooter()
        }
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
            //TODO: map is not centered on user location as soon as the app is launched, only after some location updates
            
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
    
    static func AdamHome() -> MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.145129, longitude: 24.368676), latitudinalMeters: 1000, longitudinalMeters: 1000)
    }
    
    static func userCenteredRegion(userCoordinates: CLLocationCoordinate2D) -> MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userCoordinates.latitude, longitude: userCoordinates.longitude), latitudinalMeters: 1000, longitudinalMeters: 1000)
    }
}