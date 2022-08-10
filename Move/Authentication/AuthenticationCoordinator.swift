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
}

class AuthenticationCoordinatorViewModel: ObservableObject {
    @Published var state: AuthenticationState = .register
}

struct AuthenticationCoordinatorView: View {
    @StateObject var viewModel = AuthenticationCoordinatorViewModel()
    
    var body: some View {
        switch viewModel.state {
        case .register:
            RegisterView {
                viewModel.state = .login
            }
        case .login:
            LoginView {
                viewModel.state = .register
            }
        }
    }
}

struct AuthenticationCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationCoordinatorView()
    }
}
