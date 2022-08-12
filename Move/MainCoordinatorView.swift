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


struct MainCoordinatorView: View {
    @State private var currentState: MainCoordinatorState? = .splash
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: SplashView(afterAppear: {
                    currentState = .onboarding
                }).ignoresSafeArea().navigationBarBackButtonHidden(true), tag: .splash, selection: $currentState, label: { EmptyView() })
                
                NavigationLink(destination: OnboardingView(onFinished: {
                    currentState = .authentication
                }).navigationBarBackButtonHidden(true), tag: .onboarding, selection: $currentState, label: { EmptyView() })
                
                NavigationLink(destination: AuthenticationView(onFinished: {
                    currentState = .addLicense
                }).navigationBarBackButtonHidden(true), tag: .authentication, selection: $currentState, label: { EmptyView() })
                
                NavigationLink(destination: AddLicenseView(onFinished: {}).navigationBarBackButtonHidden(true), tag: .addLicense, selection: $currentState, label: { EmptyView() })
                    
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
