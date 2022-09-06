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
    
    var currentRegion: Binding<MKCoordinateRegion>? {
        guard let location = userLocation else {
            return MKCoordinateRegion.ClujCentralRegion().getBinding()
        }
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        return region.getBinding()
    }
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
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
}

extension MKCoordinateRegion {
    static func ClujCentralRegion() -> MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.769484, longitude: 23.589884), latitudinalMeters: 4000, longitudinalMeters: 4000)
    }
    
    func getBinding() -> Binding<MKCoordinateRegion>? {
        return Binding<MKCoordinateRegion>(.constant(self))
    }
}

class FindScootersViewModel: ObservableObject{
    @StateObject private var locationManager = LocationManger()
    
    func getUserLocation() -> CLLocation? {
        locationManager.userLocation
    }
    
    func getCurrentRegion() -> Binding<MKCoordinateRegion>? {
        locationManager.currentRegion
    }
}

struct FindScootersView: View {
    @StateObject private var viewModel = FindScootersViewModel()
    
    var body: some View {
        if let region = viewModel.getCurrentRegion() {
            Map(coordinateRegion: region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .constant(.follow))
                .ignoresSafeArea()
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        FindScootersView()
    }
}
