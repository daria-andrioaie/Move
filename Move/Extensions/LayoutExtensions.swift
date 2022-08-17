//
//  LayoutExtensions.swift
//  Move
//
//  Created by Daria Andrioaie on 16.08.2022.
//

import Foundation
import SwiftUI

struct FrameModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
    }
}

extension View {
    func alignLeadingWithHorizontalPadding() -> some View {
        modifier(FrameModifier())
    }
}
