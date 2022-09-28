//
//  ScooterUnlockOptionsView.swift
//  Move
//
//  Created by Daria Andrioaie on 16.09.2022.
//

import SwiftUI

struct UnlockOptionsButtons: View {
    let onUnlock: (UnlockMethod) -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            Button("NFC") {
                onUnlock(.NFCUnlock)
            }
            .frame(maxWidth: .infinity)
            .lightActiveButton()
            
            Button("QR") {
                onUnlock(.QRUnlock)
            }
            .frame(maxWidth: .infinity)
            .lightActiveButton()
            
            Button("123") {
                onUnlock(.PINUnlock)
            }
            .frame(maxWidth: .infinity)
            .lightActiveButton()
        }
    }
}

struct ScooterImageUnlockView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("rectangleBackground-unlockView")
                .offset(y: -15)
            Image("xiaomi-unlockView")
        }
        .offset(x: 20)
    }
}

struct ScooterDetailsUnlockView: View {
    let scooterNumber: Int
    let batteryPercentage: Int
    
    var body: some View {
        Text("Scooter")
            .font(.primary(.medium, size: 16))
            .foregroundColor(.primaryBlue)
        Text("#\(scooterNumber)")
            .font(.primary(.bold, size: 32))
            .foregroundColor(.primaryBlue)
        ScooterBatteryView(batteryPercentage: batteryPercentage)
    }
}


struct ScooterUnlockOptionsView: View {
    let scooterData: ScooterData
    let onUnlock: (UnlockMethod) -> Void

    var body: some View {
        
        VStack(spacing: 25) {
            Text("You can unlock this scooter \n through these methods:")
                .font(.primary(type: .button1))
                .foregroundColor(.primaryBlue)
            
            HStack {
                VStack(alignment: .leading) {
                    ScooterDetailsUnlockView(scooterNumber: scooterData.scooterNumber, batteryPercentage: scooterData.battery)
                    
                    HStack {
                        MapButtonView(imagePath: "bell-pink") {
                            print("ring bell")
                        }
                        Text("Ring")
                            .font(.primary(type: .button2))
                            .foregroundColor(.primaryBlue)
                    }
                    .padding(.top, 10)
                    HStack {
                        MapButtonView(imagePath: "location-missing") {
                            print("missing scooter")

                        }
                        Text("Missing")
                            .font(.primary(type: .button2))
                            .foregroundColor(.primaryBlue)
                    }
                    
                }
                .padding(.leading, 5)
                .frame(maxWidth: .infinity, alignment: .leading)

                
                ScooterImageUnlockView()
                    .frame(maxWidth: .infinity, alignment: .trailing)

            }
            .frame(maxWidth: .infinity)
            
            UnlockOptionsButtons(onUnlock: onUnlock)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 30)
//        .background(RoundedRectangle(cornerRadius: 29)
//            .foregroundColor(.white)
//            .shadow(color: Color(red: 33/255, green: 11/255, blue: 80/255, opacity: 0.15), radius: 20, x: 0, y: 0))
        
    }
}

struct ScooterUnlockOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                ScooterUnlockOptionsView(scooterData: .init(_id: "alaal", scooterNumber: 1234, bookedStatus: "free", lockedStatus: "unlocked", battery: 100, location: .init(coordinates: [23.123456, 46.123456], address: "Strada Avram Iancu nr .26 Cladirea 2")), onUnlock: {_ in })
                    .previewDevice(device)
            }
        }
    }
}
