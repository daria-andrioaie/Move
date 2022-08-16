//
//  Shared.swift
//  Move
//
//  Created by Daria Andrioaie on 16.08.2022.
//

import Foundation
import SwiftUI

struct HeaderView: View {
    let title: String
    let caption: String
    
    var body: some View {
        Image("littleIcon")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 14)
            .padding(.bottom, 20)

        Text(title)
            .font(.primary(type: .heading1))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 20)

        Text(caption)
            .font(.primary(type: .heading2))
            .foregroundColor(.neutralPurple)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
    }
}

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
