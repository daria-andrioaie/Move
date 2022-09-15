//
//  MapView.swift
//  Move
//
//  Created by Daria Andrioaie on 06.09.2022.
//

import SwiftUI
import Foundation
import MapKit
import CoreLocation

final class LocationManger: NSObject, ObservableObject {
    @Published var userLocation: CLLocation?
    
    private let locationManager = CLLocationManager()
//    var currentRegion: Binding<MKCoordinateRegion>? {
//        guard let location = userLocation else {
//            return MKCoordinateRegion.ClujCentralRegion().getBinding()
//        }
//        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
//        return region.getBinding()
//    }
  
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            
            // this is the default value anyway
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        else {
            // TODO: alert the user
        }
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            //TODO: show an alert
            print("Location is restricted")
        case .denied:
            //TODO: show an alert
            print("Location is denied. go to settings")
        case .authorizedAlways, .authorizedWhenInUse:
            // update the ui to show the current user location
            break
        @unknown default:
            break
        }
    }
}

extension LocationManger: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            return
        }
        DispatchQueue.main.async {
            self.userLocation = lastLocation
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

//extension MKCoordinateRegion {
//    static func ClujCentralRegion() -> MKCoordinateRegion {
//        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.769484, longitude: 23.589884), latitudinalMeters: 4000, longitudinalMeters: 4000)
//    }
//
//    func getBinding() -> Binding<MKCoordinateRegion>? {
//        return Binding<MKCoordinateRegion>(.constant(self))
//    }
//}



struct FindScootersView: View {
    let onMenuButtonPressed: () -> Void
    @StateObject private var viewModel = FindScootersViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            ScooterMapView(viewModel: viewModel.mapViewModel)
                .onAppear {
                    viewModel.loadScooters()
                    viewModel.refreshScootersEvery30Seconds()
                }
            MapHeaderView {
                onMenuButtonPressed()
            } onLocationButtonPressed: {
                viewModel.centerMapOnUserLocation()
            }
            if let selectedScooterAnnotation = viewModel.selectedScooterAnnotation {
                ScooterCardView(scooterData: selectedScooterAnnotation.scooterData)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
                //TODO: scooter detail view is not animated on dissappear
            }
        }
    }
}

struct FindScootersView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                FindScootersView(onMenuButtonPressed: {})
                    .previewDevice(device)
            }
        }
    }
}
