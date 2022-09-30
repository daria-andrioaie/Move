//
//  ChangePasswordView.swift
//  Move
//
//  Created by Daria Andrioaie on 15.09.2022.
//

import SwiftUI

class ChangePasswordViewModel: ObservableObject {
    @Published var oldPassword = ""
    @Published var newPassword = ""
    @Published var confirmedPassword = ""

    
    func saveEdits() {
        
    }
    
}

struct ChangePasswordFieldsView: View {
    var oldPassword: Binding<String>
    var newPassword: Binding<String>
    var confirmedPassword: Binding<String>
    let colorScheme: ColorScheme
    
    var body: some View {
        VStack {
            SecureUnderlinedTextField(placeholder: "Old password", inputValue: oldPassword, colorScheme: colorScheme)
            SecureUnderlinedTextField(placeholder: "New password", inputValue: newPassword, colorScheme: colorScheme)
            SecureUnderlinedTextField(placeholder: "Confirm new password", inputValue: confirmedPassword, colorScheme: colorScheme)
        }
    }
}


struct ChangePasswordView: View {
    @StateObject var viewModel = ChangePasswordViewModel()
    let onBack: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    private var formIsCompleted: Bool {
        if !viewModel.oldPassword.isEmpty && !viewModel.newPassword.isEmpty && !viewModel.confirmedPassword.isEmpty {
            return true
        }
        return false
    }
    
    var body: some View {
        VStack {
            HeaderView(buttonAction: .slideBack, onButtonPressed: {
                print("Go back to menu")
                onBack()
            }, headerTitle: "Change password")
            .padding(.horizontal, 24)
            
            ChangePasswordFieldsView(oldPassword: $viewModel.oldPassword, newPassword: $viewModel.newPassword, confirmedPassword: $viewModel.confirmedPassword, colorScheme: colorScheme)
                .padding(.top, 30)

            Spacer()
            
            FormButton(title: "Save edits", isEnabled: formIsCompleted) {
                viewModel.saveEdits()
            }
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                ChangePasswordView(onBack: {})
                    .preferredColorScheme(.light)
                    .previewDevice(device)
            }
        }
    }
}
