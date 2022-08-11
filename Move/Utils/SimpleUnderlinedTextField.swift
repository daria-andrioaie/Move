//
//  UnderlinedTextField.swift
//  Move
//
//  Created by Daria Andrioaie on 10.08.2022.
//

import Foundation
import SwiftUI

extension View {
    func placeholder<Content: View>(when shouldShow: Bool, @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: .leading) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct SecureUnderlinedTextField: View {
    var placeholder: String
    
    @Binding var binding: String
    @FocusState var fieldIsFocused: Bool
    @State private var showText = false
    
    var body: some View {
        ZStack {
            if !showText {
                SecureField("", text: $binding)
                    .frame(width: 327)
                    .placeholder(when: binding.isEmpty) {
                        Text(placeholder).foregroundColor(.white)
                            .opacity(0.6)
                            .font(.primary(type: .body1))
                    }
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .focused($fieldIsFocused)
                    .overlay(Rectangle().frame(height: fieldIsFocused ? 2 : 1).padding(.top, 45))
                    .foregroundColor(.white)
                    .font(.primary(type: .body1))
                    .opacity(fieldIsFocused ? 1 : 0.6)
                    .padding(.bottom, 50)
                
                if fieldIsFocused {
                    Button {
                        print("button pressed")
                        showText.toggle()
                    } label: {
                        Image("eye-opened")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 55)
                            .offset(y: -20)
                    }
                }
            }
            else {
                TextField("", text: $binding)
                    .frame(width: 327)
                    .placeholder(when: binding.isEmpty) {
                        Text(placeholder).foregroundColor(.white)
                            .opacity(0.6)
                            .font(.primary(type: .body1))
                    }
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .focused($fieldIsFocused)
                    .overlay(Rectangle().frame(height: fieldIsFocused ? 2 : 1).padding(.top, 45))
                    .foregroundColor(.white)
                    .font(.primary(type: .body1))
                    .opacity(fieldIsFocused ? 1 : 0.6)
                    .padding(.bottom, 50)
                
                if fieldIsFocused {
                    Button {
                        print("button pressed")
                        showText.toggle()
                    } label: {
                        Image("eye-closed")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 55)
                            .offset(y: -20)
                    }
                }
            }
        }
    }
}

struct SimpleUnderlinedTextField: View {
    var placeholder: String
    
    @Binding var binding: String
    @FocusState var fieldIsFocused: Bool
    
    var body: some View {
        ZStack {
            TextField("", text: $binding)
                .frame(width: 327)
                .placeholder(when: binding.isEmpty) {
                    Text(placeholder).foregroundColor(.white)
                        .opacity(0.6)
                        .font(.primary(type: .body1))
                }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .focused($fieldIsFocused)
                .overlay(Rectangle().frame(height: fieldIsFocused ? 2 : 1).padding(.top, 45))
                .foregroundColor(.white)
                .font(.primary(type: .body1))
                .opacity(fieldIsFocused ? 1 : 0.6)
                .padding(.bottom, 50)
            if fieldIsFocused {
                Button {
                    binding = ""
                } label: {
                    Image("close-circle")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 45)
                        .offset(y: -20)
                }
            }
        }
            
    }
}
