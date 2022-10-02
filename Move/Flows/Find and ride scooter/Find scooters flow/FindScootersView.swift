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


struct SelectedScooterSheetView: View {
    var userCanUnlockScooter: Bool
    var selectedScooterAnnotation: ScooterAnnotation
    @Binding var unlockOptionsSheetDisplayMode: SheetDisplayMode
    @Binding var startRideSheetDisplayMode: SheetDisplayMode
    let userLocationCoordinates: CLLocationCoordinate2D?
    let onUnlock: (UnlockMethod) -> Void
    let onStartRide: () -> Void
    let onDismissStartRideSheet: () -> Void

    var body: some View {
        switch selectedScooterAnnotation.getScooterData().lockedStatus {
        case .locked:
            ScooterCardView(scooterData: selectedScooterAnnotation.scooterData, userCanUnlockScooter: userCanUnlockScooter, userLocationCoordinates: userLocationCoordinates, onUnlock: {
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
            FlexibleSheet(sheetMode: $startRideSheetDisplayMode, onDismiss: {
                onDismissStartRideSheet()
            }) {
                StartRideCardView(scooterData: selectedScooterAnnotation.scooterData, onStartRide: onStartRide)
            }
            .zIndex(3)
        }
    }
}

struct FindScootersView: View {
    let onMenuButtonPressed: () -> Void
    let onUnlock: (UnlockMethod) -> Void
    let onStartedRideSuccessfully: (Ride) -> Void
    
    @StateObject private var viewModel: FindScootersViewModel
    
    init(selectedScooter: SelectedScooterViewModel, onMenuButtonPressed: @escaping () -> Void, onUnlock: @escaping (UnlockMethod) -> Void, onStartedRideSuccessfully: @escaping (Ride) -> Void) {
        self.onMenuButtonPressed = onMenuButtonPressed
        self.onUnlock = onUnlock
        self.onStartedRideSuccessfully = onStartedRideSuccessfully
        self._viewModel = StateObject(wrappedValue: FindScootersViewModel(selectedScooter: selectedScooter))
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScooterMapView(viewModel: viewModel.mapViewModel)
                .onAppear {
                    viewModel.loadScooters()
                    viewModel.refreshScootersEvery30Seconds()
                }
            MapHeaderView(address: viewModel.mapCenterAddress, isUserLocationAvailable: viewModel.mapViewModel.isUserLocationAvailable) {
                onMenuButtonPressed()
            } onLocationButtonPressed: {
                if viewModel.mapViewModel.isUserLocationAvailable {
                    viewModel.centerMapOnUserLocation()
                }
                else {
                    SwiftMessagesErrorHandler().handle(message: "To center the map on your current location, you need to allow Move to access your location.", buttonLabel: "Go to settings", type: .warning, onScreenDuration: 4) {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                }
            }
            if let selectedScooterAnnotation = viewModel.selectedScooter.value {
                SelectedScooterSheetView(userCanUnlockScooter: viewModel.mapViewModel.isUserLocationAvailable, selectedScooterAnnotation: selectedScooterAnnotation, unlockOptionsSheetDisplayMode: $viewModel.unlockOptionsSheetDisplayMode, startRideSheetDisplayMode: $viewModel.selectedScooter.startRideSheetDisplayMode, userLocationCoordinates: viewModel.mapViewModel.userLocation?.coordinate, onUnlock: onUnlock, onStartRide: {
                    viewModel.startRideOnCurrentUnlockedScooter { result in
                        switch result {
                        case .success(let ride):
                            SwiftMessagesErrorHandler().handle(message: "successfully started ride with id: \(ride._id)", type: .error)
                            onStartedRideSuccessfully(ride)
                        case .failure(let apiError):
                            viewModel.lockUnlockedScooter()
                            SwiftMessagesErrorHandler().handle(message: apiError.message, type: .error)
                        }
                    }
                }, onDismissStartRideSheet: {
                    viewModel.lockUnlockedScooter()
                })
            }
        }
        .ignoresSafeArea()
    }
}

struct FindScootersView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                FindScootersView(selectedScooter: .constant, onMenuButtonPressed: {}, onUnlock: { _ in }, onStartedRideSuccessfully: { _ in })
                    .previewDevice(device)
            }
        }
    }
}
