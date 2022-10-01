//
//  MenuButtonView.swift
//  Move
//
//  Created by Daria Andrioaie on 08.09.2022.
//

import SwiftUI

struct MapButtonView: View {
    let imagePath: String
    let isEnabled: Bool
    let onTap: () -> Void
    
    init(imagePath: String, isEnabled: Bool = true, onTap: @escaping () -> Void) {
        self.imagePath = imagePath
        self.isEnabled = isEnabled
        self.onTap = onTap
    }
    
    var body: some View {
        Button {
            onTap()
        } label: {
            Image(imagePath)
                .mapButton()
        }
        .disabled(!isEnabled)
    }
}

struct ShadowedMapButtonView: View {
    let imagePath: String
    let onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            Image(imagePath)
                .mapShadowedButton()
        }
    }
}


struct MapButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MapButtonView(imagePath: "menu-button", onTap: {})
    }
}
