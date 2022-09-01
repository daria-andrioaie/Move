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

struct LoadingDisabledButton: View {
    var body: some View {
        Button {}
        label: {
             ActivityIndicator()
                .frame(width: 25, height: 25)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .largeDisabledButton()
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
    }
}