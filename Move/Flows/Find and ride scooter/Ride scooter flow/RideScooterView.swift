//
//  RideScooterView.swift
//  Move
//
//  Created by Daria Andrioaie on 26.09.2022.
//

import SwiftUI

struct RideScooterView: View {
    @StateObject var viewModel = RideScooterViewModel()
    let onSuccessfullyEndedRide: () -> Void

    let onMenuButtonPressed: () -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            ScooterMapView(viewModel: viewModel.mapViewModel)
            MapHeaderView(address: viewModel.mapCenterAddress, isUserLocationAvailable: viewModel.mapViewModel.isUserLocationAvailable) {
                onMenuButtonPressed()
            } onLocationButtonPressed: {
                viewModel.centerMapOnUserLocation()
            }
            if viewModel.tripDetailsSheetMode != .none {
                FlexibleSheet(sheetMode: $viewModel.tripDetailsSheetMode, onDismiss: {
                    viewModel.tripDetailsSheetMode = .custom
                }) {
                    if viewModel.tripDetailsSheetMode == .custom {
                        TripDetailsMinimisedView(scooterData: viewModel.scooterData, timeInSeconds: viewModel.timeElapsed, distanceInMeters: viewModel.distanceCovered, onLockUnlock: {
                            viewModel.toggleLockStatusOfScooter()
                        }, onEndRide: {
                            viewModel.endRide { result in
                                switch result {
                                case .success(_):
                                    onSuccessfullyEndedRide()
                                case .failure(let apiError):
                                    SwiftMessagesErrorHandler().handle(message: apiError.message)
                                }
                            }
                        })
                    }
                    else if viewModel.tripDetailsSheetMode == .full {
                        TripDetailsFullView(scooterData: viewModel.scooterData, timeInSeconds: viewModel.timeElapsed, distanceInMeters: viewModel.distanceCovered, onDismiss: {
                            withAnimation {
                                viewModel.tripDetailsSheetMode = .custom
                            }
                        }, onLockUnlock: {
                            viewModel.toggleLockStatusOfScooter()
                        }, onEndRide: {
                            viewModel.endRide { result in
                                switch result {
                                case .success(_):
                                    onSuccessfullyEndedRide()
                                case .failure(let apiError):
                                    SwiftMessagesErrorHandler().handle(message: apiError.message)
                                }
                            }
                        })
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct RideScooterView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                RideScooterView(onSuccessfullyEndedRide: {}, onMenuButtonPressed: {})
            }
        }
        
    }
}
