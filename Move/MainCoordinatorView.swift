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
    private let userDefaultsService: UserDefaultsService
    
    init(userDefaultsService: UserDefaultsService) {
        self.userDefaultsService = userDefaultsService
    }
    
    var userState: UserState {
        do {
            let currentUser = try userDefaultsService.getUser()
            if let userToken = try? userDefaultsService.getUserToken() {
                print(userToken)
            }
            print("user \(currentUser.username) with is logged in. He is \(currentUser.status)")
            // the user was successfully decoded
            if currentUser.status == "suspended" {
                return .suspended
            }
            return .active
        }
        catch CodingError.cannotDecodeUser {
            print("Can't decode user")
            return .notLoggedIn
        }
        catch UserDefaultsServiceError.cannotFindKey {
            print("No user logged in")
            // no user saved in UserDefaults
            // determine if it's the first time launching the app or not
            
//            if userDefaultsService.isAppOnFirstLaunch() {
//                userDefaultsService.setAppAlreadyLanchedOnce()
//                return .firstUseOfApplication
//            }
//            else {
//                return .notLoggedIn
//            }
            return .firstUseOfApplication
        }
        catch {
            print("Unexpected error: \(error)")
            
            //TODO: what should I return in this case?
            return .notLoggedIn
        }
    }
}

struct MainCoordinatorView: View {
    private let errorHandler: SwiftMessagesErrorHandler
    private let userDefaultsService: UserDefaultsService
    private let authenticationAPIService: AuthenticationAPIService
    @State private var currentState: MainCoordinatorState? = .splash
    @StateObject private var viewModel: MainCoordinatorViewModel
    
    init(errorHandler: SwiftMessagesErrorHandler, userDefaultsService: UserDefaultsService, authenticationAPIService: AuthenticationAPIService) {
        self.errorHandler = errorHandler
        self.userDefaultsService = userDefaultsService
        self.authenticationAPIService = authenticationAPIService
        self._viewModel = StateObject(wrappedValue: MainCoordinatorViewModel(userDefaultsService: userDefaultsService))
    }
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: SplashView(afterAppear: {
//                    currentState = .authentication
                    switch viewModel.userState {
                    case .firstUseOfApplication:
                        currentState = .onboarding
                    case .notLoggedIn:
//                        currentState = .rideScooter
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
                
                NavigationLink(destination: AuthenticationView(errorHandler: self.errorHandler, authenticationAPIService: self.authenticationAPIService, onFinished: {
//                    currentState = .addLicense
                    switch viewModel.userState {
                    case .firstUseOfApplication:
                        //TODO: handle this case
                        return
                    case .notLoggedIn:
                        //TODO: also this one
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
                
                //TODO: set the color scheme of views on this flow
                NavigationLink(destination: LicenseCoordinatorView(authenticationAPIService: self.authenticationAPIService, errorHandler: self.errorHandler, onFinished: {
                    currentState = .rideScooter
                }, onBack: {
                    currentState = .authentication
                })
                    .navigationBarHidden(true)
                    .transition(.opacity.animation(.default))
                    .navigationBarBackButtonHidden(true), tag: .addLicense, selection: $currentState, label: { EmptyView() })
                
                //TODO: set the color scheme of views on this flow
                NavigationLink(destination: RideCoordinatorView(onLogout: {
                    currentState = .authentication
                })
                    .navigationBarHidden(true)
                    .transition(.opacity.animation(.default))
                    .navigationBarBackButtonHidden(true), tag: .rideScooter, selection: $currentState) { EmptyView() }
//                NavigationLink(destination:
//                                PINUnlockView(onCancelUnlock: {}, onUnlockSuccessful: {})
//                    .navigationBarHidden(true)
//                    .transition(.opacity.animation(.default))
//                    .navigationBarBackButtonHidden(true), tag: .rideScooter, selection: $currentState) { EmptyView() }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MainCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        MainCoordinatorView(errorHandler: SwiftMessagesErrorHandler(), userDefaultsService: UserDefaultsService(), authenticationAPIService: AuthenticationAPIService(userDefaultsService: UserDefaultsService()))
    }
}
