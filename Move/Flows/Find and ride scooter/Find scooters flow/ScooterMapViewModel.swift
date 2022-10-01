//
//  ScooterMapViewModel.swift
//  Move
//
//  Created by Daria Andrioaie on 13.09.2022.
//

import Foundation
import MapKit
import SwiftUI

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
        print("scooter map view model instantiated")
        super.init()
        configureLocationManager()
    }
    
    var scooters: [ScooterAnnotation] = [] {
        didSet {
            refreshScooterList()
        }
    }
    
    var isUserLocationAvailable: Bool {
        return self.userLocation != nil
    }
    
    var onSelectedScooter: (ScooterAnnotation) -> Void = { _ in }
    var onDeselectedScooter: () -> Void = {}
    var onMapRegionChanged: (String) -> Void = { _ in }
    
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.mapType = .mutedStandard
//        mapView.setRegion(MKCoordinateRegion.AdamHome(), animated: true)

        mapView.setRegion(MKCoordinateRegion.ClujCentralRegion(), animated: true)
        
        mapView.showAnnotations(mapView.annotations, animated: true)
        mapView.showsUserLocation = true
        mapView.delegate = self
        return mapView
    }()
    
    func refreshScooterList() {
        // if one scooter is selected and it's card view is displayed
        if mapView.selectedAnnotations.count >= 1 {
            if let selectedScooter = mapView.selectedAnnotations[0] as? ScooterAnnotation {
                mapView.removeAnnotations(mapView.annotations)
                mapView.addAnnotations(scooters)
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
            mapView.removeAnnotations(mapView.annotations.filter({ annotation in
                if let scooterAnnotation = annotation as? ScooterAnnotation {
                    return scooterAnnotation.scooterData.lockedStatus == .locked
                }
                else {
                    return true
                }
            }))
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
//        mapView.setRegion(MKCoordinateRegion.AdamHome(), animated: true)
        mapView.setRegion(MKCoordinateRegion.ClujCentralRegion(), animated: true)
    }
    
    func getAllScooters() {
        let service = ScootersAPIService()
        service.getScootersInArea(center: mapView.centerCoordinate, radius: 4000) { result in
            switch result {
            case .success(let scooters):
//                for scooter in scooters {
//                    print(scooter.toString())
//                }
                self.scooters = scooters.getAnnotations()
            case .failure(let error):
                print("\(error.message)")
            }
        }
//        self.scooters = ScooterAnnotation.requestMockData()
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
        refreshAddressOfMapCenter()
    }
    
    func refreshAddressOfMapCenter() {
        CLGeocoder().reverseGeocodeLocation(.init(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude)) { placemarks, error in
            if let error = error {
                print("Reverse geocoder failed with error: " + error.localizedDescription)
                return
            }
            
            if let placemarks = placemarks {
                if placemarks.count > 0 {
                    let mapCenterPlacemark = placemarks[0] as CLPlacemark
                    
                    if let cityName = mapCenterPlacemark.locality {
                        var addressOfMapCenter = cityName
                        if let additionalCityInformation = mapCenterPlacemark.subLocality {
                            addressOfMapCenter += ", \(additionalCityInformation)"
                        }
                        self.onMapRegionChanged(addressOfMapCenter)
                    }
                    else {
                        self.onMapRegionChanged("No address detected")
                    }
                } else {
                    print("Problem with the data received from geocoder")
                }
            }
        }
    }
}

extension ScooterMapViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let shouldCenterOnUserLocation = self.userLocation == nil
        
        guard let lastLocation = locations.last else {
            return
        }
//        DispatchQueue.main.async {
            self.userLocation = lastLocation
            if shouldCenterOnUserLocation {
                withAnimation {
                    self.centerMapOnUserLocation()
                }
            }
//        }
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
            self.userLocation = nil
            print("Location is restricted")
        case .denied:
            //TODO: show an alert
            centerMapOnClujCityCenter()
            self.userLocation = nil
            print("Location is denied. go to settings")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
//            self.centerMapOnUserLocation()
            locationManager.startUpdatingLocation()
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
