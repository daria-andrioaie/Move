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

struct FieldModifier: ViewModifier {
    var placeholder: String

    @Binding var inputValue: String
    @FocusState var fieldIsFocused: Bool
    let colorScheme: ColorScheme
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .placeholder(when: inputValue.isEmpty) {
                Text(placeholder).foregroundColor(colorScheme == .light ? .black : .white)
                    .opacity(0.6)
                    .font(.primary(type: .body1))
            }
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .focused($fieldIsFocused)
            .overlay(Rectangle().frame(height: fieldIsFocused ? 2 : 1).padding(.top, 45))
            .foregroundColor(colorScheme == .light ? .primaryBlue : .white)
            .font(.primary(type: .body1))
            .opacity(fieldIsFocused ? 1 : 0.6)
            .padding(.bottom, 50)
            .padding(.horizontal, 24)
    }
}

extension View {
    func fieldModifier(placeholder: String, inputValue: Binding<String>, fieldIsFocused: FocusState<Bool>, colorScheme: ColorScheme) -> some View {
        modifier(FieldModifier(placeholder: placeholder, inputValue: inputValue, fieldIsFocused: fieldIsFocused, colorScheme: colorScheme))
    }
}

struct FieldIconView: View {
    let onClick: () -> Void
    let imagePath: String
    
    var body: some View {
        Button {
            onClick()
        } label: {
            Image(imagePath)
//                .offset(x: UIScreen.main.bounds.width / 2)
                .padding(.trailing, 30)
                .padding(.bottom, 40)
        }
    }
}

struct SecureUnderlinedTextField: View {
    var placeholder: String
    
    @Binding var inputValue: String
    @FocusState var fieldIsFocused: Bool
    let colorScheme: ColorScheme

    @State private var showText = false
    
    var body: some View {
        ZStack {
            if !showText {
                SecureField("", text: $inputValue)
                    .fieldModifier(placeholder: placeholder, inputValue: $inputValue, fieldIsFocused: _fieldIsFocused, colorScheme: colorScheme)
                
                if fieldIsFocused {
                    FieldIconView(onClick: {
                        showText.toggle()
                    }, imagePath: "eye-opened")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            else {
                TextField("", text: $inputValue)
                    .fieldModifier(placeholder: placeholder, inputValue: $inputValue, fieldIsFocused: _fieldIsFocused, colorScheme: colorScheme)
                
                if fieldIsFocused {
                    FieldIconView(onClick: {
                        showText.toggle()
                    }, imagePath: "eye-closed")
                    .frame(maxWidth: .infinity, alignment: .trailing)

                }
            }
        }
    }
}

struct SimpleUnderlinedTextField: View {
    var placeholder: String
    
    @Binding var inputValue: String
    @FocusState var fieldIsFocused: Bool
    let colorScheme: ColorScheme
    
    var body: some View {
        ZStack {
            TextField("", text: $inputValue)
                .fieldModifier(placeholder: placeholder, inputValue: $inputValue, fieldIsFocused: _fieldIsFocused, colorScheme: colorScheme)
            
            if fieldIsFocused {
                FieldIconView(onClick: {
                    inputValue = ""
                }, imagePath: "close-circle")
                .frame(maxWidth: .infinity, alignment: .trailing)

            }
        }
            
    }
}
