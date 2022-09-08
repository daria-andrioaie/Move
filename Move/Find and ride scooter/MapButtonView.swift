//
//  MenuButtonView.swift
//  Move
//
//  Created by Daria Andrioaie on 08.09.2022.
//

import SwiftUI

struct MapButtonView: View {
    let type: String
    let onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            Image(type)
                .mapShadowedButton()
        }

    }
}

struct MapButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MapButtonView(type: "menu-button", onTap: {})
    }
}
