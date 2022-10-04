//
//  RideScooterCoordinatorView.swift
//  Move
//
//  Created by Daria Andrioaie on 31.08.2022.
//

import SwiftUI

enum RideCoordinatorState: String, IdentifiableHashable {
    case findScooter
    case unlockScooter
//    case menuOverview
    case rideInProgress
    case payRide
    
    var id: String {
        return self.rawValue
    }
}

class SelectedScooterViewModel: ObservableObject {
    @Published var value: ScooterAnnotation? {
        didSet {
            computeAddress()
        }
    }
    @Published var scooterAddress: String = "loading.."
    @Published var startRideSheetDisplayMode = SheetDisplayMode.none
    
    static var constant: SelectedScooterViewModel {
        SelectedScooterViewModel()
    }
    
    func computeAddress() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.scooterAddress = "Calea Turzii"
        }
    }
}

class RideCoordinatorViewModel: ObservableObject {
    @Published var state: RideCoordinatorState? = .rideInProgress
    @Published var unlockMethod: UnlockMethod? = .PINUnlock
    @Published var showingMenu = false
    
    var currentStateBasedOnOngoingRide: RideCoordinatorState {
        do {
            let currentRide = try UserDefaultsService().getRide()
            print("Ride \(currentRide._id) is \(currentRide.status)")
            // the ride was successfully decoded
            if currentRide.status == .inProgress {
                return .rideInProgress
            }
            else {
                return .payRide
            }
        }
        catch CodingError.cannotDecodeRide {
            print("Can't decode ride")
            return .findScooter
        }
        catch UserDefaultsServiceError.cannotFindKey {
            print("No ride ongoing")
            return .findScooter
        }
        catch {
            print("Unexpected error: \(error)")
            return .findScooter
        }
    }
    
    init() {
        state = currentStateBasedOnOngoingRide
    }
    
}

struct RideCoordinatorView: View {
    let onLogout: () -> Void
    
    @StateObject var coordinatorViewModel: RideCoordinatorViewModel = .init()
    @StateObject var selectedScooter: SelectedScooterViewModel = .init()
    
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    VStack {
                        NavigationLink(destination: FindScootersView(selectedScooter: selectedScooter, onMenuButtonPressed: {
                            withAnimation {
                                print("showing menu")
                                coordinatorViewModel.showingMenu = true
                            }
                        }, onUnlock: { unlockMethod in
                            coordinatorViewModel.unlockMethod = unlockMethod
                            coordinatorViewModel.state = .unlockScooter
                        }, onStartedRideSuccessfully: { ride in
                            coordinatorViewModel.state = .rideInProgress
                        })
                            .preferredColorScheme(.light)
                            .navigationBarHidden(true)
                            .ignoresSafeArea()
                            .transition(.opacity.animation(.default))
                            .navigationBarBackButtonHidden(true), tag: .findScooter, selection: $coordinatorViewModel.state) {
                            EmptyView()
                        }
                        NavigationLink(destination: unlockCoordinator, tag: .unlockScooter, selection: $coordinatorViewModel.state) {
                            EmptyView()
                        }
                        
                        NavigationLink(destination: RideScooterView(onSuccessfullyEndedRide: {
                            coordinatorViewModel.state = .payRide
                        }, onMenuButtonPressed: {
                            coordinatorViewModel.showingMenu = true
                        })
                            .preferredColorScheme(.light)
                            .navigationBarHidden(true)
                            .ignoresSafeArea()
                            .navigationBarBackButtonHidden(true), tag: .rideInProgress, selection: $coordinatorViewModel.state) {
                            EmptyView()
                        }
                        
                        NavigationLink(destination: PayRideView(onSuccessfullyPaidRide: {
                            selectedScooter.value = nil
                            coordinatorViewModel.state = .findScooter
                        })
                            .preferredColorScheme(.light)
                            .navigationBarHidden(true)
                            .ignoresSafeArea()
                            .navigationBarBackButtonHidden(true), tag: .payRide, selection: $coordinatorViewModel.state) {
                                EmptyView()
                            }
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
            if coordinatorViewModel.showingMenu {
                MenuCoordinatorView(onBack: {
                    withAnimation {
                        coordinatorViewModel.showingMenu = false
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
        if case .unlockScooter = coordinatorViewModel.state {
            UnlockCoordinator(initialUnlock: coordinatorViewModel.unlockMethod!, onCancelUnlock: {
                coordinatorViewModel.state = .findScooter
            }, onUnlockFinished: {
                selectedScooter.value?.scooterData.lockedStatus = .unlocked
                selectedScooter.startRideSheetDisplayMode = .custom
                coordinatorViewModel.state = .findScooter
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
