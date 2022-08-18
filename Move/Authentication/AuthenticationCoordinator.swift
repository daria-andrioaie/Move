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

class AuthenticationViewModel: ObservableObject {
    @Published var state: AuthenticationState? = .register
}

struct AuthenticationView: View {
    @StateObject var viewModel = AuthenticationViewModel()
    let onFinished: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: RegisterView(onSwitch: {
                    viewModel.state = .login
                }, onFinished: {
                    onFinished()
                })
                    .navigationBarHidden(true)
                    .ignoresSafeArea()
                    .transition(.opacity.animation(.default))
                    .navigationBarBackButtonHidden(true), tag: .register, selection: $viewModel.state) {
                    EmptyView()
                }
                NavigationLink(destination: LoginView(onSwitch: {
                    viewModel.state = .register
                }, onForgotPassword: {
                    viewModel.state = .forgotPassword
                }, onFinished: {
                    onFinished()
                })
                .ignoresSafeArea()
                .transition(.opacity.animation(.default))
                .navigationBarBackButtonHidden(true), tag: .login, selection: $viewModel.state, label: {
                    EmptyView()
                })

                NavigationLink(destination: ForgotPasswordView(onBack: {
                    viewModel.state = .login
                })
                    .ignoresSafeArea()
                    .transition(.opacity.animation(.default))
                    .navigationBarBackButtonHidden(true), tag: .forgotPassword, selection: $viewModel.state, label: {
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
                AuthenticationView {}
                    .previewDevice(device)
            }
        }
    }
}
