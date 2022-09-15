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
    @State private var showingMenu = false
    
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    VStack {
                        NavigationLink(destination: FindScootersView(onMenuButtonPressed: {
                            withAnimation {
                                print("showing menu")
                                showingMenu = true
                            }
                        })
                            .preferredColorScheme(.light)
                            .navigationBarHidden(true)
                            .ignoresSafeArea()
                            .transition(.opacity.animation(.default))
                            .navigationBarBackButtonHidden(true), tag: .findScooter, selection: $state) {
                            EmptyView()
                        }
                    }
                    
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
            if showingMenu {
                MenuCoordinatorView(onBack: {
                    withAnimation {
                        showingMenu = false
                    }
                }, onLogout: onLogout)
                .transition(.move(edge: .leading))
                .padding(.top, 15)
                //TODO: prevent this view from enetering the safe area at the top
            }
        }
    }
}



struct RideCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                RideCoordinatorView(onLogout: {})
                    .previewDevice(device)
            }
        }
    }
}
