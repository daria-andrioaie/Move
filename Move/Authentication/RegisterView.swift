//
//  RegisterView.swift
//  Move
//
//  Created by Daria Andrioaie on 09.08.2022.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(when shouldShow: Bool, @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: .leading) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct UnderlinedTextField: View {
    var placeholder: String
    @Binding var binding: String
    var isPrivate: Bool
    
    var body: some View {
        if isPrivate {
            SecureField("", text: $binding)
                .frame(width: 337)
    //                    .offset(x: -5)
                .placeholder(when: binding.isEmpty) {
                    Text(placeholder).foregroundColor(Color("NeutralPurple"))
                        .font(.custom("BaiJamjuree-Medium", size: 16))
                }
                
                .overlay(Rectangle().frame(height: 1).padding(.top, 45))
                .foregroundColor(Color("NeutralPurple"))
                .padding(.bottom, 50)
        }
        else {
            TextField("", text: $binding)
                .frame(width: 337)
    //                    .offset(x: -5)
                .placeholder(when: binding.isEmpty) {
                    Text(placeholder).foregroundColor(Color("NeutralPurple"))
                        .font(.custom("BaiJamjuree-Medium", size: 16))
                }
                .overlay(Rectangle().frame(height: 1).padding(.top, 45))
                .foregroundColor(Color("NeutralPurple"))
                .padding(.bottom, 50)
        }
    }
}

struct RegisterView: View {
    @State private var emailAddress = ""
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Image("littleIcon")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 34)

                Text("Let's get started")
                    .font(.custom("BaiJamjuree-Bold", size: 32))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 42)
                    .padding(.bottom, 20)

                Text("Sign up or login and start riding right away")
                    .font(.custom("BaiJamjuree-Medium", size: 20))
                    .foregroundColor(Color("NeutralPurple"))
                    .frame(width: 283, alignment: .leading)
                    .offset(x: -27)
                    .padding(.bottom, 24)
     
                
                UnderlinedTextField(placeholder: "Email address", binding: $emailAddress, isPrivate: false)
                
                UnderlinedTextField(placeholder: "Username", binding: $username, isPrivate: false)

                UnderlinedTextField(placeholder: "Password", binding: $password, isPrivate: true)
                
                Text("By continuing you agree to Move’s  Terms and Conditions and Privacy Policy")
                    .font(.custom("BaiJamjuree-Regular", size: 12))
                    .foregroundColor(.white)
                    .frame(width: 231)
                    .padding(.leading, -110)
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
