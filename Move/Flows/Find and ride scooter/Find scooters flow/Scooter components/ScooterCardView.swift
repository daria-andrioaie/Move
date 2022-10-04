//
//  ScooterDetailsView.swift
//  Move
//
//  Created by Daria Andrioaie on 08.09.2022.
//

import SwiftUI
import CoreLocation

struct ScooterDetailsView: View {
    let scooterNumber: Int
    let batteryPercentage: Int
    
    var body: some View {
        Text("Scooter")
            .font(.primary(.light, size: 14))
            .foregroundColor(.primaryBlue)
        Text("#\(scooterNumber)")
            .font(.primary(.bold, size: 20))
            .foregroundColor(.primaryBlue)
        ScooterBatteryView(batteryPercentage: batteryPercentage)
    }
}

struct ScooterBatteryIcon: View {
    let batteryPercentage: Int
    
    var body: some View {
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
    }
}

struct ScooterBatteryView: View {
    let batteryPercentage: Int
    
    var body: some View {
        HStack {
            ScooterBatteryIcon(batteryPercentage: batteryPercentage)
            Text("\(batteryPercentage)%")
                .font(.primary(type: .body1))
                .foregroundColor(.primaryBlue)
        }
    }
}



struct AddressView: View {
    let address: String
    
    var body: some View {
        HStack {
            Image("location-pin")
            Text(address)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .font(.primary(type: .button2))
                .foregroundColor(.primaryBlue)
        }
        .padding(.horizontal, 24)
    }
}

struct LocateScooterButtonsView: View {
    let scooterLongitude: Double
    let scooterLatitude: Double
    let onRingButton: () -> Void
    let isUserLocationAvailable: Bool
    
    func openMaps() {
        let url = URL(string: "comgooglemaps://?saddr=&daddr=\(scooterLatitude),\(scooterLongitude)&directionsmode=walking")
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
        else{
            let urlBrowser = URL(string: "https://www.google.co.in/maps/dir/??saddr=&daddr=\(scooterLatitude),\(scooterLongitude)&directionsmode=walking")
            UIApplication.shared.open(urlBrowser!, options: [:], completionHandler: nil)
        }
    }
    
    var body: some View {
        HStack(spacing: 30) {
            MapButtonView(imagePath: "bell-pink", isEnabled: isUserLocationAvailable) {
                onRingButton()
            }
            MapButtonView(imagePath: "navigation-pink") {
                openMaps()
            }
        }
        .padding(.top, 15)
    }
}

struct ScooterImageCardView: View {
    var body: some View {
        ZStack(alignment: .top) {
            Image("rectangleBackground-cardView")
                .resizable()
                .scaledToFit()
            Image("xiaomi-cardView")
                .padding(.top, 10)
        }
    }
}

class ScooterCardViewModel: ObservableObject {
    let scooterData: ScooterData
    let userLocationCoordinates: CLLocationCoordinate2D?
    let tcpAPIService = TcpAPIService()

    init(scooterData: ScooterData, userLocationCoordinates: CLLocationCoordinate2D?) {
        self.scooterData = scooterData
        self.userLocationCoordinates = userLocationCoordinates
    }
    
    func pingScooter() {
        guard let userLocationCoordinates = userLocationCoordinates else {
            return
        }
        
        let userLocationParameters = ["longitude": userLocationCoordinates.longitude, "latitude": userLocationCoordinates.latitude]
        
        tcpAPIService.pingScooter(scooterNumber: String(scooterData.scooterNumber), userLocationCoordinates: userLocationParameters) { result in
            switch result {
            case .success(_):
                print("successfully pinged scooter")
                return
            case .failure(let apiError):
                SwiftMessagesErrorHandler().handle(message: "Couldn't ping scooter. \(apiError.message)", type: .warning)
            }
        }
    }
}

struct ScooterCardView: View {
    let scooterData: ScooterData
    var userCanUnlockScooter: Bool
    let userLocationCoordinates: CLLocationCoordinate2D?

    let onUnlock: () -> Void
    @StateObject var viewModel: ScooterCardViewModel
    
    init(scooterData: ScooterData, userCanUnlockScooter: Bool, userLocationCoordinates: CLLocationCoordinate2D?, onUnlock: @escaping () -> Void) {
        self.scooterData = scooterData
        scooterData.getAddress()
        self.userCanUnlockScooter = userCanUnlockScooter
        self.userLocationCoordinates = userLocationCoordinates
        self.onUnlock = onUnlock
        self._viewModel = StateObject(wrappedValue: ScooterCardViewModel(scooterData: scooterData, userLocationCoordinates: userLocationCoordinates))
    }
    
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                ScooterImageCardView()
                VStack(alignment: .trailing, spacing: 5) {
                    ScooterDetailsView(scooterNumber: scooterData.scooterNumber, batteryPercentage: scooterData.battery)
                    LocateScooterButtonsView(scooterLongitude: scooterData.location.coordinates[0], scooterLatitude: scooterData.location.coordinates[1], onRingButton: viewModel.pingScooter, isUserLocationAvailable: userLocationCoordinates != nil)
                }
                .padding(.trailing, 30)
                .padding(.top, 20)
            }
            AddressView(address: scooterData.location.address ?? "no address detected")
            FormButton(title: "Unlock", isEnabled: userCanUnlockScooter) {
                onUnlock()
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
                ScooterCardView(scooterData: .mockedScooter(), userCanUnlockScooter: true, userLocationCoordinates: .init(latitude: 46.245632, longitude: 23.456789), onUnlock: {})
                    .previewDevice(device)
            }
        }
    }
}
