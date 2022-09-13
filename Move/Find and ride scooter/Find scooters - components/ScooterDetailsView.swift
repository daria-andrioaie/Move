//
//  ScooterDetailsView.swift
//  Move
//
//  Created by Daria Andrioaie on 08.09.2022.
//

import SwiftUI

struct ScooterBatteryView: View {
    let batteryPercentage: Int
    
    var body: some View {
        HStack {
            switch batteryPercentage {
            case 0..<40:
                Image("battery-0")
            case 40..<60:
                Image("battery-40")
            case 60..<80:
                Image("battery-60")
            case 80..<100:
                Image("battery-80")
            case 100:
                Image("battery-100")
            default:
                Text("error")
            }
            Text("\(batteryPercentage)%")
                .font(.primary(type: .button2))
                .foregroundColor(.primaryBlue)
        }
    }
}

struct ScooterDetailsView: View {
    let scooterData: ScooterData
    
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                ZStack(alignment: .top) {
                    Image("ScooterViewRectangleBackground")
                        .resizable()
                        .scaledToFit()
                    Image("xiaomi-preview")
                        .padding(.top, 10)
                }
                VStack(alignment: .trailing, spacing: 5) {
                    Text("Scooter")
                        .font(.primary(.light, size: 14))
                        .foregroundColor(.primaryBlue)
                    Text("#\(scooterData.scooterNumber)")
                        .font(.primary(.bold, size: 20))
                        .foregroundColor(.primaryBlue)
                    ScooterBatteryView(batteryPercentage: scooterData.battery)
                    HStack(spacing: 30) {
                        MapButtonView(imagePath: "bell-pink") {
                            print("ring bell")
                        }
                        MapButtonView(imagePath: "navigation-pink") {
                            let longitude = scooterData.location.coordinates[0]
                            let latitude = scooterData.location.coordinates[1]
                            let url = URL(string: "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=walking")
                            if UIApplication.shared.canOpenURL(url!) {
                                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                            }
                            else{
                                  let urlBrowser = URL(string: "https://www.google.co.in/maps/dir/??saddr=&daddr=\(latitude),\(longitude)&directionsmode=walking")
                                            
                                   UIApplication.shared.open(urlBrowser!, options: [:], completionHandler: nil)
                            }
                        }
                    }
                    .padding(.top, 15)
                }
                .padding(.trailing, 30)
                .padding(.top, 20)
            }
            HStack {
                Image("location-pin")
                Text(scooterData.location.address ?? "No address yet")
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .font(.primary(type: .button2))
                    .foregroundColor(.primaryBlue)
            }
            .padding(.horizontal, 24)
            FormButton(title: "Unlock") {
                print("unlocked scooter")
            }
        }
        .background(RoundedRectangle(cornerRadius: 29)
            .foregroundColor(.white))
        .padding(.horizontal, 65)
        .padding(.bottom, 46)
        .shadow(color: Color(red: 0.698, green: 0.667, blue: 0.761, opacity: 0.5), radius: 20, x: 7, y: 7)
    }
}

struct ScooterDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                ScooterDetailsView(scooterData: .init(_id: "alaal", scooterNumber: 1234, bookedStatus: "free", lockedStatus: "unlocked", battery: 100, location: .init(coordinates: [23.123456, 46.123456], address: "Strada Avram Iancu nr .26 Cladirea 2")))
                    .previewDevice(device)
            }
        }
    }
}
