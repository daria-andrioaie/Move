//
//  RideScooterCoordinatorView.swift
//  Move
//
//  Created by Daria Andrioaie on 31.08.2022.
//

import SwiftUI

enum RideCoordinatorState: IdentifiableHashable {
    case findScooter
    case unlockScooter
//    case menuOverview
    case rideInProgress
    case payRide
    
    var id: String {
        switch self {
        case .findScooter: return "findScooter"
        case .unlockScooter: return "unlockScooter"
//        case .menuOverview:
        case .rideInProgress: return "rideScooter"
        case .payRide: return "payRide"
        }
    }
    
}

class SelectedScooterViewModel: ObservableObject {
    @Published var value: ScooterAnnotation?
    @Published var startRideSheetDisplayMode = SheetDisplayMode.none
    
    static var constant: SelectedScooterViewModel {
        SelectedScooterViewModel()
    }
}

struct RideCoordinatorView: View {
    let onLogout: () -> Void
    
    @State private var state: RideCoordinatorState? = .findScooter
    @State private var unlockMethod: UnlockMethod? = .PINUnlock
    @State private var showingMenu = false
//    @State private var selectedScooterAnnotation: ScooterAnnotation? = .init(scooterData: .mockedScooter(), coordinate: .init(latitude: 46.123456, longitude: 23.123456))
    @StateObject var selectedScooter: SelectedScooterViewModel = .init()
    
    
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    VStack {
                        NavigationLink(destination: FindScootersView(selectedScooter: selectedScooter, onMenuButtonPressed: {
                            withAnimation {
                                print("showing menu")
                                showingMenu = true
                            }
                        }, onUnlock: { unlockMethod in
                            self.unlockMethod = unlockMethod
                            state = .unlockScooter
                        })
                            .preferredColorScheme(.light)
                            .navigationBarHidden(true)
                            .ignoresSafeArea()
                            .transition(.opacity.animation(.default))
                            .navigationBarBackButtonHidden(true), tag: .findScooter, selection: $state) {
                            EmptyView()
                        }
                        NavigationLink(destination: unlockCoordinator, tag: .unlockScooter, selection: $state) {
                            EmptyView()
                        }
                        
                        NavigationLink(destination: RideScooterView(onMenuButtonPressed: {
                            showingMenu = true
                        })
                            .preferredColorScheme(.light)
                            .navigationBarHidden(true)
                            .ignoresSafeArea()
                            .navigationBarBackButtonHidden(true), tag: .rideInProgress, selection: $state) {
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
    
    @ViewBuilder
    var unlockCoordinator: some View {
        if case .unlockScooter = state {
            UnlockCoordinator(initialUnlock: unlockMethod!, onCancelUnlock: {
                state = .findScooter
            }, onUnlockFinished: {
                selectedScooter.value?.scooterData.lockedStatus = .unlocked
                selectedScooter.startRideSheetDisplayMode = .half
                state = .findScooter
            })
                .preferredColorScheme(.dark)
                .navigationBarHidden(true)
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
                
        }
        else {
            Color.red
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
