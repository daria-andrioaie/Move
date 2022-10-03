//
//  Buttons.swift
//  Move
//
//  Created by Daria Andrioaie on 10.08.2022.
//

import Foundation
import SwiftUI

struct FormButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void
    
    init(title: String, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(title) {
            action()
        }
        .frame(maxWidth: .infinity)
        .largeButton(isEnabled: isEnabled)
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
    }
}

struct ApplePayButton<Content: View>: View {
    let action: () -> Void
    let label: () -> Content
    
    init(action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Content) {
        self.action = action
        self.label = label
    }
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            label()
        })
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .frame(height: 56)
        .background(RoundedRectangle(cornerRadius: 16).foregroundColor(.black))
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
    }
}

struct LoadingDisabledButton: View {
    var body: some View {
        Button {}
        label: {
             ActivityIndicator()
                .frame(width: 25, height: 25)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .disabledButton()
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
    }
}
