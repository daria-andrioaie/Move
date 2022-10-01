//
//  RideScooterView.swift
//  Move
//
//  Created by Daria Andrioaie on 26.09.2022.
//

import SwiftUI

struct RideScooterView: View {
    @StateObject var viewModel = RideScooterViewModel(scooterData: .mockedScooter())
    
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
                FlexibleSheet(sheetMode: $viewModel.tripDetailsSheetMode) {
                    if viewModel.tripDetailsSheetMode == .half {
                        TripDetailsMinimisedView(scooterData: viewModel.scooterData)
                    }
                    else if viewModel.tripDetailsSheetMode == .full {
                        
                    }
                }
            }
        }
    }
}

struct RideScooterView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                RideScooterView(onMenuButtonPressed: {})
            }
        }
        
    }
}
