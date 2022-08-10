//
//  Buttons.swift
//  Move
//
//  Created by Daria Andrioaie on 10.08.2022.
//

import Foundation
import SwiftUI

struct LargeActiveButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.custom("BaiJamjuree-Bold", size: 16))
            .frame(width: 327, height: 56)
            .background(RoundedRectangle(cornerRadius: 16).foregroundColor(Color("AccentPink")))
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
            .foregroundColor(Color("NeutralPurple"))
            .font(.custom("BaiJamjuree-Regular", size: 16))
            .frame(width: 327, height: 56)
            .background(RoundedRectangle(cornerRadius: 16).stroke(Color("AccentPink"), lineWidth: 0.5))
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
