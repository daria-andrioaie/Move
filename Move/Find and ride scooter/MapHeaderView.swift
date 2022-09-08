//
//  MapHeaderView.swift
//  Move
//
//  Created by Daria Andrioaie on 08.09.2022.
//

import SwiftUI

struct MapHeaderView: View {
    var body: some View {
        HStack {
            MapButtonView(imagePath: "menu-button", onTap: {
                print("go to menu")
            })
            Spacer()
            MapButtonView(imagePath: "location-button", onTap: {
                print("center on user location")
            })
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 64)
        .background(LinearGradient(colors: [.white.opacity(1), .white.opacity(0.75), .white.opacity(0)], startPoint: .top, endPoint: .bottom))
    }
}

struct MapHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        MapHeaderView()
    }
}
