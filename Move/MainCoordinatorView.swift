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
}

class MainCoordinatorViewModel: ObservableObject {
    func isUserLoggedIn() -> Bool {
        if let userData = UserDefaults.standard.value(forKey: "currentUser") as? Data {
            if let decodedUser = try? JSONDecoder().decode(User.self, from: userData) {
                print("\(decodedUser.username) is logged in")
            }
            return true
        }
        return false
    }
}

struct MainCoordinatorView: View {
    @State private var currentState: MainCoordinatorState? = .splash
    @StateObject private var viewModel = MainCoordinatorViewModel()
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: SplashView(afterAppear: {
                    currentState = .onboarding
//                    switch viewModel.isUserLoggedIn() {
//                    case true:
//                        currentState = .addLicense
//                    case false:
//                        currentState = .onboarding
//                    }

                }).ignoresSafeArea()
                    .preferredColorScheme(.dark)
                    .transition(.opacity.animation(.default))
                    .navigationBarBackButtonHidden(true), tag: .splash, selection: $currentState, label: { EmptyView() })
                
                NavigationLink(destination: OnboardingView(onFinished: {
                    currentState = .authentication
                })
                    .preferredColorScheme(.dark)
                    .transition(.opacity.animation(.default))
                    .navigationBarBackButtonHidden(true), tag: .onboarding, selection: $currentState, label: { EmptyView() })
                
                NavigationLink(destination: AuthenticationView(onFinished: {
                    currentState = .addLicense
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
