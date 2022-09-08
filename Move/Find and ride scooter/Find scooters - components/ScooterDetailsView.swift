//
//  ScooterDetailsView.swift
//  Move
//
//  Created by Daria Andrioaie on 08.09.2022.
//

import SwiftUI

struct ScooterDetailsView: View {
    let scooterData: ScooterData
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Image("location-pin")
                    Text(scooterData.location.address)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .font(.primary(type: .button2))
                        .foregroundColor(.primaryBlue)
                }
                FormButton(title: "Unlock") {
                    print("unlocked scooter")
                }
            }
        }
        .background(RoundedRectangle(cornerRadius: 29)
            .foregroundColor(.neutralPink))
        .padding(70)
    }
}

struct ScooterDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ScooterDetailsView(scooterData: .init(_id: "alaal", scooterNumber: 1234, bookedStatus: "free", lockedStatus: "unlocked", battery: 100, location: .init(coordinates: [23.123456, 46.123456], address: "Strada Avram Iancu nr .26 Cladirea 2")))
    }
}
