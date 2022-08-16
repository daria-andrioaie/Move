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
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .placeholder(when: inputValue.isEmpty) {
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
            .padding(.horizontal, 24)
    }
}

extension View {
    func fieldModifier(placeholder: String, inputValue: Binding<String>, fieldIsFocused: FocusState<Bool>) -> some View {
        modifier(FieldModifier(placeholder: placeholder, inputValue: inputValue, fieldIsFocused: fieldIsFocused))
    }
}

struct IconView: View {
    let onClick: () -> Void
    let imagePath: String
    
    var body: some View {
        Button {
            onClick()
        } label: {
            Image(imagePath)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 30)
                .padding(.bottom, 40)
        }
    }
}

struct SecureUnderlinedTextField: View {
    var placeholder: String
    
    @Binding var inputValue: String
    @FocusState var fieldIsFocused: Bool
    @State private var showText = false
    
    var body: some View {
        ZStack {
            if !showText {
                SecureField("", text: $inputValue)
                    .fieldModifier(placeholder: placeholder, inputValue: $inputValue, fieldIsFocused: _fieldIsFocused)
                
                if fieldIsFocused {
                    IconView(onClick: {
                        showText.toggle()
                    }, imagePath: "eye-opened")
                }
            }
            else {
                TextField("", text: $inputValue)
                    .fieldModifier(placeholder: placeholder, inputValue: $inputValue, fieldIsFocused: _fieldIsFocused)
                
                if fieldIsFocused {
                    IconView(onClick: {
                        showText.toggle()
                    }, imagePath: "eye-closed")
                }
            }
        }
    }
}

struct SimpleUnderlinedTextField: View {
    var placeholder: String
    
    @Binding var inputValue: String
    @FocusState var fieldIsFocused: Bool
    
    var body: some View {
        ZStack {
            TextField("", text: $inputValue)
                .fieldModifier(placeholder: placeholder, inputValue: $inputValue, fieldIsFocused: _fieldIsFocused)
            
            if fieldIsFocused {
                IconView(onClick: {
                    inputValue = ""
                }, imagePath: "close-circle")
            }
        }
            
    }
}
