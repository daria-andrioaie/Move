//
//  MapHeaderView.swift
//  Move
//
//  Created by Daria Andrioaie on 08.09.2022.
//

import SwiftUI

struct MapHeaderView: View {
    let address: String?
    let isUserLocationAvailable: Bool
    let onMenuButtonPressed: () -> Void
    let onLocationButtonPressed: () -> Void
    
    var body: some View {
        HStack {
            ShadowedMapButtonView(imagePath: "menu-button", onTap: {
                onMenuButtonPressed()
            })
            Spacer()
            Text(isUserLocationAvailable ? (address ?? "no address detected") : "Allow location")
                .foregroundColor(.primaryPurple)
                .font(.primary(type: .navbarTitle))
            
            Spacer()
            ShadowedMapButtonView(imagePath: isUserLocationAvailable ? "user-location-button" : "user-location-disabled-button", onTap: {
                onLocationButtonPressed()
            })
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 64)
        .background(LinearGradient(colors: [.white.opacity(1), .white.opacity(0.75), .white.opacity(0)], startPoint: .top, endPoint: .bottom))
    }
}

struct MapHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        MapHeaderView(address: "Cluj Napoca", isUserLocationAvailable: true){
            print("go to menu")
        } onLocationButtonPressed: {
            print("center map")
        }

    }
}
