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
    let onUnlock: (UnlockMethod) -> Void

    var body: some View {
        switch selectedScooterAnnotation.getScooterData().lockedStatus {
        case .locked:
            ScooterCardView(scooterData: selectedScooterAnnotation.scooterData, userCanUnlockScooter: userCanUnlockScooter, onUnlock: {
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
                StartRideCardView(scooterData: selectedScooterAnnotation.scooterData)
            }
            .zIndex(3)
        }
    }
}

struct FindScootersView: View {
    let onMenuButtonPressed: () -> Void
    let onUnlock: (UnlockMethod) -> Void
    
    @StateObject private var viewModel: FindScootersViewModel
    
    init(selectedScooter: SelectedScooterViewModel, onMenuButtonPressed: @escaping () -> Void, onUnlock: @escaping (UnlockMethod) -> Void) {
        print("view instantiated")
        self.onMenuButtonPressed = onMenuButtonPressed
        self.onUnlock = onUnlock
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
                SelectedScooterSheetView(userCanUnlockScooter: viewModel.mapViewModel.isUserLocationAvailable, selectedScooterAnnotation: selectedScooterAnnotation, unlockOptionsSheetDisplayMode: $viewModel.unlockOptionsSheetDisplayMode, startRideSheetDisplayMode: $viewModel.selectedScooter.startRideSheetDisplayMode, onUnlock: onUnlock)
            }
        }
        .ignoresSafeArea()
    }
}

struct FindScootersView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                FindScootersView(selectedScooter: .constant, onMenuButtonPressed: {}, onUnlock: {_ in })
                    .previewDevice(device)
            }
        }
    }
}
