//
//  ButtonStylesExtensions.swift
//  Move
//
//  Created by Daria Andrioaie on 17.08.2022.
//

import Foundation
import SwiftUI

struct ActiveButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.primary(type: .button1))
            .frame(height: 56)
            .background(RoundedRectangle(cornerRadius: 16).foregroundColor(.accentPink))
    }
}

extension View {
    func activeButton() -> some View {
        modifier(ActiveButtonModifier())
    }
}


struct DisabledButtonModifier: ViewModifier {
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
    func disabledButton() -> some View {
        modifier(DisabledButtonModifier())
    }
}

extension View {
    
    @ViewBuilder
    func largeButton(isEnabled: Bool) -> some View {
        if isEnabled {
            modifier(ActiveButtonModifier())
        }
        else {
            modifier(DisabledButtonModifier())
        }
    }
}

struct LightActiveButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.accentPink)
            .font(.primary(type: .button1SemiBold))
            .frame(height: 56)
            .background(RoundedRectangle(cornerRadius: 16).stroke(Color.accentPink, lineWidth: 1))
    }
}

extension View {
    func lightActiveButton() -> some View {
        
        modifier(LightActiveButtonModifier())
    }
}


struct MapButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 36, height: 36)
            .overlay(content: {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.neutralCement, lineWidth: 0.5)
            })
    }
}

struct MapShadowedButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 36, height: 36)
            .background(RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white))
            .shadow(color: Color(red: 0.698, green: 0.667, blue: 0.761, opacity: 0.5), radius: 10, x: 7, y: 7)
    }
}

extension View {
    func mapShadowedButton() -> some View {
        modifier(MapShadowedButtonModifier())
    }
    
    func mapButton() -> some View {
        modifier(MapButtonModifier())
    }
}
