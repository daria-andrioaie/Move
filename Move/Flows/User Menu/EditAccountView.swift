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
    
    func logout() {
        
    }
}

struct FieldsView: View {
    var username: Binding<String>
    var emailAddress: Binding<String>
    let colorScheme: ColorScheme
    
    var body: some View {
        VStack {
            SimpleUnderlinedTextField(placeholder: "Username", inputValue: username, colorScheme: .light)
                .foregroundColor(.primaryBlue)
                .padding(.top, 30)
            SimpleUnderlinedTextField(placeholder: "Email address", inputValue: emailAddress, colorScheme: colorScheme)
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
    
    @Environment(\.colorScheme) var colorScheme

    
    private var formIsCompleted: Bool {
        if !viewModel.emailAddress.isEmpty && !viewModel.username.isEmpty {
            return true
        }
        
        return false
    }
    
    var body: some View {
        VStack {
            HeaderView(onBack: {
                print("Go back to menu")
                onBack()
            }, headerTitle: "Account")
            .padding(.horizontal, 24)
            
            FieldsView(username: $viewModel.username, emailAddress: $viewModel.emailAddress, colorScheme: colorScheme)
                .padding(.top, 30)
            
            Spacer()
            
            LogoutView {
                viewModel.logout()
            }
            .padding(.bottom, 45)
            
            FormButton(title: "Save edits", isEnabled: formIsCompleted) {
                viewModel.saveEdits()
            }
        }
    }
}

struct EditAccountView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                EditAccountView(onBack: {})
                    .preferredColorScheme(.light)
                    .previewDevice(device)
            }
        }
    }
}
