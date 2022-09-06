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
    
}

class FindScootersViewModel: ObservableObject{
    let locationManager = LocationManger()
}

struct FindScootersView: View {
    @StateObject private var viewModel = FindScootersViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        FindScootersView()
    }
}
