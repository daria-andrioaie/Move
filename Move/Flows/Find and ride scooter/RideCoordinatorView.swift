//
//  RideScooterCoordinatorView.swift
//  Move
//
//  Created by Daria Andrioaie on 31.08.2022.
//

import SwiftUI

enum RideCoordinatorState {
    case findScooter
    case menuOverview
    case rideInProgress
    case payRide
}

struct RideCoordinatorView: View {
    let onLogout: () -> Void
    
    @State private var state: RideCoordinatorState? = .findScooter
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: FindScootersView(onMenuButtonPressed: {
                    state = .menuOverview
                })
                    .preferredColorScheme(.light)
                    .navigationBarHidden(true)
                    .ignoresSafeArea()
                    .transition(.opacity.animation(.default))
                    .navigationBarBackButtonHidden(true), tag: .findScooter, selection: $state) {
                    EmptyView()
                }
                
                NavigationLink(destination: MenuCoordinatorView(onBack: {
                    state = .findScooter
                }, onLogout: onLogout)
                    .preferredColorScheme(.light)
                    .navigationBarHidden(true)
                    .ignoresSafeArea()
                    .transition(.opacity.animation(.default))
                    .navigationBarBackButtonHidden(true), tag: .menuOverview, selection: $state) {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct RideCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                RideCoordinatorView()
                    .previewDevice(device)
            }
        }
    }
}
