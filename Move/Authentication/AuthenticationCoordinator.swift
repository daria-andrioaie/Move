//
//  AuthenticationCoordinator.swift
//  Move
//
//  Created by Daria Andrioaie on 10.08.2022.
//

import SwiftUI

enum AuthenticationState {
    case register
    case login
    case forgotPassword
}

//class AuthenticationViewModel: ObservableObject {
//    @Published var state: AuthenticationState? = .register
//}

struct AuthenticationView: View {
//    @StateObject var viewModel = AuthenticationViewModel()
    let errorHandler: SwiftMessagesErrorHandler
    @State var state: AuthenticationState? = .register
    let onFinished: () -> Void
    
//    init(errorHandler: SwiftMessagesErrorHandler, onFinished: @escaping () -> Void) {
//        self.errorHandler = errorHandler
//        self.onFinished = onFinished
//    }
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: RegisterView(errorHandler: self.errorHandler, onSwitch: {
                    state = .login
                }, onFinished: {
                    onFinished()
                })
                    .navigationBarHidden(true)
                    .ignoresSafeArea()
                    .transition(.opacity.animation(.default))
                    .navigationBarBackButtonHidden(true), tag: .register, selection: $state) {
                    EmptyView()
                }
                NavigationLink(destination: LoginView(errorHandler: self.errorHandler, onSwitch: {
                    state = .register
                }, onForgotPassword: {
                    state = .forgotPassword
                }, onFinished: {
                    onFinished()
                })
                    .ignoresSafeArea()
                    .transition(.opacity.animation(.default))
                    .navigationBarBackButtonHidden(true), tag: .login, selection: $state, label: {
                    EmptyView()
                })

                NavigationLink(destination: ForgotPasswordView(onBack: {
                    state = .login
                })
                    .ignoresSafeArea()
                    .transition(.opacity.animation(.default))
                    .navigationBarBackButtonHidden(true), tag: .forgotPassword, selection: $state, label: {
                    EmptyView()
                })
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                AuthenticationView(errorHandler: .shared, onFinished: {})
                    .previewDevice(device)
            }
        }
    }
}
