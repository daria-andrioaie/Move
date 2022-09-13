//
//  LicenseCoordinatorView.swift
//  Move
//
//  Created by Daria Andrioaie on 05.09.2022.
//

import SwiftUI

enum AddLicenseState {
    case addLicense
    case validationInPogress
    case validationSuccessful
}

struct LicenseCoordinatorView: View {
    @State private var state: AddLicenseState? = .addLicense
    let authenticationAPIService: AuthenticationAPIService
    let errorHandler: SwiftMessagesErrorHandler
    let onFinished: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: AddLicenseView(authenticationAPIService: self.authenticationAPIService, errorHandler: self.errorHandler , onValidationInProgress: {
                    state = .validationInPogress
                }, onValidationSuccessful: {
                    state = .validationSuccessful
                }, onBack: {
                    onBack()
                })
                    .preferredColorScheme(.light)
                    .navigationBarHidden(true)
                    .transition(.opacity.animation(.default))
                    .navigationBarBackButtonHidden(true), tag: .addLicense, selection: $state) {
                    EmptyView()
                }
                
                NavigationLink(destination: ValidationInProgressView()
                    .preferredColorScheme(.dark)
                    .navigationBarHidden(true)
                    .ignoresSafeArea()
                    .transition(.opacity.animation(.default))
                    .navigationBarBackButtonHidden(true), tag: .validationInPogress, selection: $state) {
                    EmptyView()
                }
                
                NavigationLink(destination: ValidationSuccessView(onFinished: {
                    onFinished()
                })
                    .preferredColorScheme(.dark)
                    .navigationBarHidden(true)
                    .ignoresSafeArea()
                    .transition(.opacity.animation(.default))
                    .navigationBarBackButtonHidden(true), tag: .validationSuccessful, selection: $state) {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LicenseCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                LicenseCoordinatorView(authenticationAPIService: AuthenticationAPIService(userDefaultsService: UserDefaultsService()), errorHandler: SwiftMessagesErrorHandler(), onFinished: {}, onBack: {})
                    .previewDevice(device)
            }
        }
    }
}
