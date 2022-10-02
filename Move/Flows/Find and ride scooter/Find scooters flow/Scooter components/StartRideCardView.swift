//
//  StartRideCardView.swift
//  Move
//
//  Created by Daria Andrioaie on 28.09.2022.
//

import SwiftUI

struct StartRideCardView: View {
    let scooterData: ScooterData
    let onStartRide: () -> Void
    
    var body: some View {
        VStack(spacing: 25) {
            HStack {
                VStack(alignment: .leading) {
                    ScooterDetailsUnlockView(scooterNumber: scooterData.scooterNumber, batteryPercentage: scooterData.battery)
                }
                
                ScooterImageUnlockView()
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity)
            Button("Start ride") {
                onStartRide()
            }
            .frame(maxWidth: .infinity)
            .activeButton()
            .shadow(color: Color(red: 0.898, green: 0.188, blue: 0.384, opacity: 0.2), radius: 20, x: 7, y: 7)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 30)
    }
}

struct StartRideCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                FlexibleSheet(sheetMode: .constant(.half)) {
                    StartRideCardView(scooterData: .mockedScooter(), onStartRide: {})
                }
                    .previewDevice(device)
            }
        }
    }
}
