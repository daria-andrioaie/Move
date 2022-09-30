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
    var selectedScooterAnnotation: ScooterAnnotation
    @Binding var unlockOptionsSheetDisplayMode: SheetDisplayMode
    @Binding var startRideSheetDisplayMode: SheetDisplayMode
    let onUnlock: (UnlockMethod) -> Void

    var body: some View {
        switch selectedScooterAnnotation.getScooterData().lockedStatus {
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
            MapHeaderView {
                onMenuButtonPressed()
            } onLocationButtonPressed: {
                viewModel.centerMapOnUserLocation()
            }
            if let selectedScooterAnnotation = viewModel.selectedScooter.value {
                Text(selectedScooterAnnotation.scooterData.toString())
                    .foregroundColor(.black)
                    .font(.primary(type: .heading1))
                SelectedScooterSheetView(selectedScooterAnnotation: selectedScooterAnnotation, unlockOptionsSheetDisplayMode: $viewModel.unlockOptionsSheetDisplayMode, startRideSheetDisplayMode: $viewModel.selectedScooter.startRideSheetDisplayMode, onUnlock: onUnlock)
            }
        }
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
