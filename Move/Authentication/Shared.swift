//
//  Shared.swift
//  Move
//
//  Created by Daria Andrioaie on 16.08.2022.
//

import Foundation
import SwiftUI

struct AuthenticationHeaderView: View {
    let title: String
    let caption: String
    
    var body: some View {
        Image("littleIcon")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 24)
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
//            .frame(width: UIScreen.main.bounds.width)
//            .padding(.horizontal, 24)
            .padding(.bottom, 24)
    }
}


