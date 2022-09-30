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

struct SelectedScooterSheetView: View {
    var selectedScooterAnnotation: ScooterAnnotation
    @Binding var unlockOptionsSheetDisplayMode: SheetDisplayMode
    @Binding var startRideSheetDisplayMode: SheetDisplayMode
    let onUnlock: (UnlockMethod) -> Void

    var body: some View {
        switch selectedScooterAnnotation.getScooterData().lockStatus {
        case .locked:
            ScooterCardView(scooterData: selectedScooterAnnotation.scooterData, onUnlock: {
                unlockOptionsSheetDisplayMode = .half
            })
                .frame(maxHeight: .infinity, alignment: .bottom)
                .transition(.move(edge: .bottom))
                .animation(.linear(duration: 1), value: selectedScooterAnnotation != nil)
                .zIndex(1)
            
            if unlockOptionsSheetDisplayMode != .none {
                FlexibleSheet(sheetMode: $unlockOptionsSheetDisplayMode) {
                    ScooterUnlockOptionsView(scooterData: selectedScooterAnnotation.scooterData, onUnlock: onUnlock)
                    
                }
                .zIndex(2)
            }
        case .unlocked:
            FlexibleSheet(sheetMode: $startRideSheetDisplayMode) {
                ZStack {
                    Color.accentPink
                    Text("Start ride")
                        .foregroundColor(.white)
                        .font(.primary(type: .button1))
                }
            }
            .zIndex(3)
        }
    }
}

struct FindScootersView: View {
    @Binding var selectedScooterAnnotation: ScooterAnnotation?
    let onMenuButtonPressed: () -> Void
    let onUnlock: (UnlockMethod) -> Void
    
    @StateObject var viewModel: FindScootersViewModel
    
    init(selectedScooterAnnotation: Binding<ScooterAnnotation?>, onMenuButtonPressed: @escaping () -> Void, onUnlock: @escaping (UnlockMethod) -> Void) {
        self._selectedScooterAnnotation = selectedScooterAnnotation
        self.onMenuButtonPressed = onMenuButtonPressed
        self.onUnlock = onUnlock
        self._viewModel = StateObject(wrappedValue: FindScootersViewModel(selectedScooterAnnotation: selectedScooterAnnotation))
    }

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
                Text(selectedScooterAnnotation.scooterData.toString())
                    .foregroundColor(.black)
                    .font(.primary(type: .heading1))
//                SelectedScooterSheetView(selectedScooterAnnotation: selectedScooterAnnotation, unlockOptionsSheetDisplayMode: $viewModel.unlockOptionsSheetDisplayMode, startRideSheetDisplayMode: $viewModel.startRideSheetDisplayMode, onUnlock: onUnlock)
            }
        }
    }
}

struct FindScootersView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                FindScootersView(selectedScooterAnnotation: .constant(nil), onMenuButtonPressed: {}, onUnlock: {_ in })
                    .previewDevice(device)
            }
        }
    }
}
