//
//  TripDetailsFullView.swift
//  Move
//
//  Created by Daria Andrioaie on 29.09.2022.
//

import SwiftUI

struct GenericTravelMetricsRectangleView<Content>: View where Content: View {
    let metricsValue: String
    let metricsDescription: String?
    let titleView: Content
    
    init(metricsValue: String, metricsDescription: String? = nil, @ViewBuilder titleView: () -> Content) {
        self.metricsValue = metricsValue
        self.metricsDescription = metricsDescription
        self.titleView = titleView()
    }
    
    var body: some View {
        VStack {
            titleView
                .padding(.bottom, 12)
            Text(metricsValue)
                .foregroundColor(.primaryBlue)
                .font(.primary(type: .title))
            if let metricsDescription = metricsDescription {
                Text(metricsDescription)
                    .foregroundColor(.primaryBlue)
                    .font(.primary(type: .body1))
            }
        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 29)
                .stroke(Color.neutralCement, lineWidth: 1)
        )
    }
}

struct ButtonsTripDetailsFullView: View {
    var scooterLockStatus: LockStatus

    var body: some View {
        HStack {
            LockUnlockButton(scooterLockStatus: scooterLockStatus)
            EndRideButton()
        }
    }
}

struct TripDetailsFullView: View {
    @Binding var tripDetailsSheetMode: SheetDisplayMode
    
    var scooterData: ScooterData
    var timeInSeconds: Int
    var distanceInMeters: Int
    
    var body: some View {
        VStack {
            HeaderView(buttonAction: .slideDown, onButtonPressed: {
                tripDetailsSheetMode = .half
            }, headerTitle: "Trip details")
            
            GenericTravelMetricsRectangleView(metricsValue: "\(scooterData.battery)%") {
                HStack{
                    ScooterBatteryIcon(batteryPercentage: scooterData.battery)
                    Text("Battery")
                        .foregroundColor(.primaryBlue)
                        .opacity(0.6)
                        .font(.primary(type: .body1))
                }
            }
            
            GenericTravelMetricsRectangleView(metricsValue: timeInSeconds.convertToHoursMinutesSecondsFormat()) {
                GenericTravelMetricsTitle(metricsType: .time)
            }
            
            GenericTravelMetricsRectangleView(metricsValue: distanceInMeters.convertToKilometersFormat(), metricsDescription: "km") {
                GenericTravelMetricsTitle(metricsType: .distance)
            }
            
            ButtonsTripDetailsFullView(scooterLockStatus: scooterData.lockedStatus)
        }
        .padding(.horizontal, 24)
    }
    
}

struct TripDetailsFullView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                TripDetailsFullView(tripDetailsSheetMode: .constant(.full), scooterData: .mockedScooter(), timeInSeconds: 776, distanceInMeters: 2700)
                    .previewDevice(device)
            }
        }
    }
}