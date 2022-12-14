//
//  EditAccountView.swift
//  Move
//
//  Created by Daria Andrioaie on 15.09.2022.
//

import SwiftUI

class EditAccountViewModel: ObservableObject {
    @Published var username = ""
    @Published var emailAddress = ""
    
    func saveEdits() {
        
    }
    
    func logout(onRequestCompleted: @escaping (Result<String, APIError>) -> Void) {
        let authenticationService = AuthenticationAPIService(userDefaultsService: UserDefaultsService())
        authenticationService.logoutRequest { result in
            switch result {
            case .success(let userToken):
                print("Logged out user")
                onRequestCompleted(.success(userToken))
            case .failure(let apiError):
                onRequestCompleted(.failure(apiError))
            }
        }
    }
}

struct EditAccountFieldsView: View {
    var username: Binding<String>
    var emailAddress: Binding<String>
    let colorScheme: ColorScheme
    let onAllFieldsCompleted: () -> Void
    
    @FocusState var emailFieldIsFocused: Bool
    @FocusState var usernameFieldIsFocused: Bool
    
    var body: some View {
        VStack {
            SimpleUnderlinedTextField(placeholder: "Username", inputValue: username, fieldIsFocused: _usernameFieldIsFocused, colorScheme: .light, returnType: .next) {
                emailFieldIsFocused = true
            }
            SimpleUnderlinedTextField(placeholder: "Email address", inputValue: emailAddress, fieldIsFocused: _emailFieldIsFocused, colorScheme: colorScheme, returnType: .done) {
                onAllFieldsCompleted()
            }
        }
    }
}

struct LogoutView: View {
    let onLogout: () -> Void
    
    var body: some View {
        Button {
            onLogout()
        } label: {
            HStack {
                Image("logout-icon")
                Text("Log out")
                    .font(.primary(.semiBold, size: 14))
                    .foregroundColor(.red)
            }
        }
    }
}

struct EditAccountView: View {
    @StateObject var viewModel = EditAccountViewModel()
    let onBack: () -> Void
    let onLogout: () -> Void
    
    @Environment(\.colorScheme) var colorScheme

    
    private var formIsCompleted: Bool {
        if !viewModel.emailAddress.isEmpty && !viewModel.username.isEmpty {
            return true
        }
        
        return false
    }
    
    var body: some View {
        VStack {
            HeaderView(buttonAction: .slideBack, onButtonPressed: {
                print("Go back to menu")
                onBack()
            }, headerTitle: "Account")
            .padding(.horizontal, 24)
            
            EditAccountFieldsView(username: $viewModel.username, emailAddress: $viewModel.emailAddress, colorScheme: colorScheme, onAllFieldsCompleted: {
                if formIsCompleted {
                    viewModel.saveEdits()
                }
            })
                .padding(.top, 30)
            
            Spacer()
            
            LogoutView {
                viewModel.logout { result in
                    switch result {
                    case .success(_):
                        onLogout()
                    case .failure(let apiError):
                        print("Logout error: \(apiError.message)")
                    }
                }
            }
            .padding(.bottom, 45)
            
            FormButton(title: "Save edits", isEnabled: formIsCompleted) {
                viewModel.saveEdits()
            }
        }
        .onTapGesture {
            //TODO: I think this doesn't work because the fields are in a child view of this one. Similar behaviour is in ChangePasswordView
            hideKeyboard()
        }
    }
}

struct EditAccountView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                EditAccountView(onBack: {}, onLogout: {})
                    .preferredColorScheme(.light)
                    .previewDevice(device)
            }
        }
    }
}
