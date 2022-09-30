//
//  RegisterView.swift
//  Move
//
//  Created by Daria Andrioaie on 09.08.2022.
//

import SwiftUI
import SwiftMessages

//class MockedRegisterViewModel: ObservableObject {
//    let userDefaultsService: UserDefaultsService
////    let errorHandler: SwiftMessagesErrorHandler
////    let onSwitch: () -> Void
////    let onFinished: () -> Void
//
//    @Published private var requestInProgress = false
//
//    init(userDefaultsService: UserDefaultsService){
//        self.userDefaultsService = userDefaultsService
//    }
//
//    @ViewBuilder
//    func computeView() -> some View {
//        VStack {
//            Text(self.requestInProgress ? "loading" : "not loading" )
//            Text("aba")
//        }
//    }
//
//}
//
//struct RegisterView2: View {
//    @ObservedObject var viewModel: MockedRegisterViewModel
//
//    var body: some View {
//        viewModel.computeView()
//    }
//}



struct RegisterView: View {
    let authenticationAPIService: AuthenticationAPIService
    let errorHandler: SwiftMessagesErrorHandler
    let onSwitch: () -> Void
    let onFinished: () -> Void
    
    @StateObject var viewModel: RegisterViewModel
    @FocusState var emailFieldIsFocused: Bool
    @FocusState var usernameFieldIsFocused: Bool
    @FocusState var passwordFieldIsFocused: Bool
    
    @Environment(\.colorScheme) var colorScheme

    init(authenticationAPIService: AuthenticationAPIService, errorHandler: SwiftMessagesErrorHandler, onSwitch: @escaping () -> Void, onFinished: @escaping () -> Void) {
        self.authenticationAPIService = authenticationAPIService
        self.errorHandler = errorHandler
        self.onSwitch = onSwitch
        self.onFinished = onFinished
        self._viewModel = StateObject(wrappedValue: RegisterViewModel(authenticationAPIService: authenticationAPIService))
    }
    
    private var formIsCompleted: Bool {
        if !viewModel.emailAddress.isEmpty && !viewModel.username.isEmpty && !viewModel.password.isEmpty {
            return true
        }
        return false
    }
    

    var body: some View {
        ZStack {
            PurpleBackgroundView()
            ScrollView {
                VStack() {
                    AuthenticationHeaderView(title: "Let's get started", caption: "Sign up or login and start riding right away")

                    SimpleUnderlinedTextField(placeholder: "Email address", inputValue: $viewModel.emailAddress, fieldIsFocused: _emailFieldIsFocused, colorScheme: colorScheme, returnType: .next) {
                        usernameFieldIsFocused = true
                    }
                    
                    SimpleUnderlinedTextField(placeholder: "Username", inputValue: $viewModel.username, fieldIsFocused: _usernameFieldIsFocused, colorScheme: colorScheme, returnType: .next) {
                        passwordFieldIsFocused = true
                    }

                    SecureUnderlinedTextField(placeholder: "Password", inputValue: $viewModel.password, fieldIsFocused: _passwordFieldIsFocused, colorScheme: colorScheme, returnType: .done) {
                        if formIsCompleted {
                            manageRequest()
                        }
                    }

                    TermsAndConditionsNote()

                    //TODO: duplicate block ( also present in LoginView), break it into a separatecomponent and make an AuthenticationViewModelProtocol to pass as a variable
                    switch viewModel.requestInProgress {
                    case false: 
                        FormButton(title: "Get started", isEnabled: formIsCompleted) {
                            manageRequest()
                        }
                    case true:
                        LoadingDisabledButton()
                    }
                    
                    SwitchAuthenticationMethodLink(questionText: "You already have an account? You can ", linkText: "log in here", onSwitch: onSwitch)
                    .frame(maxWidth: .infinity)

                    Spacer()
                }
            }
        }
    }
    
    func manageRequest() {
        viewModel.requestInProgress = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            viewModel.register { fieldName in
                viewModel.requestInProgress = false
                errorHandler.handle(message: "The \(fieldName) you entered is invalid", type: .warning)
            } onAPIError: { error in
                viewModel.requestInProgress = false
                errorHandler.handle(message: error.message, type: .error)
            } onRegisterCompleted: {
                onFinished()
            }
        })
    }
}


struct TermsAndConditionsNote: View {
    var body: some View {
        Text("By continuing you agree to Move’s \n[Terms and Conditions](http://www.tapptitude.com/) and [Privacy Policy](http://www.tapptitude.com/).")
            .font(.primary(type: .smallText))
            .tint(.white)
            .foregroundColor(.white)
            .alignLeadingWithHorizontalPadding()
            .padding(.bottom, 32)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                RegisterView(authenticationAPIService: AuthenticationAPIService(userDefaultsService: UserDefaultsService()), errorHandler: SwiftMessagesErrorHandler(), onSwitch: {}, onFinished: {})
                    .preferredColorScheme(.dark)
                    .previewDevice(device)
            }
        }
    }
}
