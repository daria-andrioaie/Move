//
//  ButtonStylesExtensions.swift
//  Move
//
//  Created by Daria Andrioaie on 17.08.2022.
//

import Foundation
import SwiftUI

struct LargeActiveButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.primary(type: .button1))
            .frame(height: 56)
            .background(RoundedRectangle(cornerRadius: 16).foregroundColor(.accentPink))
    }
}

extension View {
    func largeActiveButton() -> some View {
        modifier(LargeActiveButtonModifier())
    }
}


struct LargeDisabledButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .disabled(true)
            .foregroundColor(.neutralPurple)
            .font(.primary(.regular, size: 16))
            .frame(height: 56)
            .background(RoundedRectangle(cornerRadius: 16).stroke(Color.accentPink, lineWidth: 0.5))
    }
}

extension View {
    func largeDisabledButton() -> some View {
        modifier(LargeDisabledButtonModifier())
    }
}

extension View {
    
    @ViewBuilder
    func largeButton(isEnabled: Bool) -> some View {
        if isEnabled {
            modifier(LargeActiveButtonModifier())
        }
        else {
            modifier(LargeDisabledButtonModifier())
        }
    }
}

struct LightActiveButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.accentPink)
            .font(.primary(.regular, size: 16))
            .frame(height: 56)
            .background(RoundedRectangle(cornerRadius: 16).stroke(Color.accentPink, lineWidth: 0.5))
    }
}

extension View {
    func lightActiveButton() -> some View {
        
        modifier(LightActiveButtonModifier())
    }
}
