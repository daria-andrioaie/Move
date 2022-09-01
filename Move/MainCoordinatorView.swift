//
//  MainCoordinatorView.swift
//  Move
//
//  Created by Daria Andrioaie on 12.08.2022.
//

import SwiftUI

enum MainCoordinatorState {
    case splash
    case onboarding
    case authentication
    case addLicense
    case rideScooter
}

enum UserState {
    case firstUseOfApplication
    case notLoggedIn
    case suspended
    case active
}

class MainCoordinatorViewModel: ObservableObject {
    
    var userState: UserState {
        if let userData = UserDefaults.standard.value(forKey: "currentUser") as? Data {
            if let decodedUser = try? JSONDecoder().decode(User.self, from: userData) {
                
                // the user was successfully decoded
                if decodedUser.status == "suspended" {
                    return .suspended
                }
                return .active
            }
            // there is a user value on UserDefaults, but it couldn't be decoded
            return .notLoggedIn
        }
        
        // no user detected
        // determine if it's the first time launching the app or not
        if UserDefaults.standard.bool(forKey: "isAppAlreadyLaunchedOnce") {
            return .notLoggedIn
        }
        else {
            UserDefaults.standard.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return .firstUseOfApplication
        }
    }
}

struct MainCoordinatorView: View {
    @State private var currentState: MainCoordinatorState? = .splash
    @StateObject private var viewModel = MainCoordinatorViewModel()
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: SplashView(afterAppear: {
//                    currentState = .authentication
                    switch viewModel.userState {
                    case .firstUseOfApplication:
                        currentState = .onboarding
                    case .notLoggedIn:
                        currentState = .authentication
                    case .suspended:
                        currentState = .addLicense
                    case .active:
                        currentState = .rideScooter
                    }

                }).ignoresSafeArea()
                    .preferredColorScheme(.dark)
                    .transition(.opacity.animation(.default))
                    .navigationBarBackButtonHidden(true), tag: .splash, selection: $currentState, label: { EmptyView() })
                
                NavigationLink(destination: OnboardingCoordinatorView(onFinished: {
                    currentState = .authentication
                })
                    .preferredColorScheme(.dark)
                    .transition(.opacity.animation(.default))
                    .navigationBarBackButtonHidden(true), tag: .onboarding, selection: $currentState, label: { EmptyView() })
                
                NavigationLink(destination: AuthenticationView(onFinished: {
//                    currentState = .addLicense
                    switch viewModel.userState {
                    case .firstUseOfApplication:
                        //TODO: also handle this case
                        return
                    case .notLoggedIn:
                        //TODO: handle this case
                        return
                    case.suspended:
                        currentState = .addLicense
                    case .active:
                        currentState = .rideScooter
                    }
                })
                    .preferredColorScheme(.dark)
                    .transition(.opacity.animation(.default))
                    .navigationBarBackButtonHidden(true), tag: .authentication, selection: $currentState, label: { EmptyView() })
                
                NavigationLink(destination: AddLicenseView(onFinished: {}, onBack: {
                        currentState = .authentication
                })
                    .navigationBarHidden(true)
                    .transition(.opacity.animation(.default))
                    .navigationBarBackButtonHidden(true), tag: .addLicense, selection: $currentState, label: { EmptyView() })
                
//                NavigationLink(destination: ValidationSuccessView()
//                    .navigationBarHidden(true)
//                    .transition(.opacity.animation(.default))
//                    .navigationBarBackButtonHidden(true), tag: .addLicense, selection: $currentState, label: { EmptyView() })
                
                NavigationLink(destination: RideScooterCoordinatorView()
                    .navigationBarHidden(true)
                    .transition(.opacity.animation(.default))
                    .navigationBarBackButtonHidden(true), tag: .rideScooter, selection: $currentState) { EmptyView() }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MainCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        MainCoordinatorView()
    }
}
