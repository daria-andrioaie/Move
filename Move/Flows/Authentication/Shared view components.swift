//
//  Shared.swift
//  Move
//
//  Created by Daria Andrioaie on 16.08.2022.
//

import Foundation
import SwiftUI
import SwiftMessages

struct AuthenticationHeaderView: View {
    let title: String
    let caption: String
    
    var body: some View {
        Image("littleIcon")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 40)
            .padding(.leading, 14)
            .padding(.bottom, 10)

        Text(title)
            .font(.primary(type: .heading1))
            .foregroundColor(.white)
            .alignLeadingWithHorizontalPadding()
            .padding(.bottom, 20)

        Text(caption)
            .font(.primary(type: .heading2))
            .foregroundColor(.neutralPurple)
            .alignLeadingWithHorizontalPadding()
            .padding(.bottom, 24)
    }
}

struct SwitchAuthenticationMethodLink: View {
    let questionText: String
    let linkText: String
    let onSwitch: () -> Void
    
    var body: some View {
        HStack {
            Text(questionText)
                .foregroundColor(.white)
                .font(.primary(type: .smallText))
            Button {
                onSwitch()
            } label: {
                Text(linkText)
                    .foregroundColor(.white)
                    .font(.primary(type: .smallText))
                    .bold()
                    .underline()
                    .offset(x: -7)
            }
        }
    }
}
