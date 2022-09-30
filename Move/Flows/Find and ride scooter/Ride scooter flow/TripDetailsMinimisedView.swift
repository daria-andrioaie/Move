//
//  TripDetailsMinimisedView.swift
//  Move
//
//  Created by Daria Andrioaie on 29.09.2022.
//

import SwiftUI

enum MetricsType {
    case distance
    case time
}

struct GenericTravelMetricsTitle: View {
    let metricsType: MetricsType
    
    var body: some View {
        HStack {
            Image(metricsType == .time ? "clock" : "map")
            Text(metricsType == .time ? "Travel time" : "Distance")
                .foregroundColor(.primaryBlue)
                .opacity(0.6)
                .font(.primary(type: .body1))
        }
    }
}

struct GenericTravelMetricsView: View {
    let metricsType: MetricsType
    let metricsValue: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            GenericTravelMetricsTitle(metricsType: metricsType)
            HStack(alignment: .firstTextBaseline) {
                Text(metricsType == .time ? metricsValue.convertToHoursAndMinutesFormat() : metricsValue.convertToKilometersFormat())
                    .foregroundColor(.primaryBlue)
                    .font(.primary(type: .heading1))
                Text(metricsType == .time ? "min" : "km")
                    .foregroundColor(.primaryBlue)
                    .font(.primary(type: .button1))
            }
        }
    }
}

struct LeftSection: View {
    var scooterData: ScooterData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            GenericTravelMetricsView(metricsType: .time, metricsValue: 720)
            
            LockUnlockButton(scooterLockStatus: scooterData.lockStatus)
        }
    }
}

struct RightSection: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            GenericTravelMetricsView(metricsType: .distance, metricsValue: 2700)
            EndRideButton()
        }
    }
}

struct TripDetailsMinimisedView: View {
    var scooterData: ScooterData
    
    var body: some View {
        VStack(spacing: 25) {
            Text("Trip details")
                .foregroundColor(.primaryBlue)
                .font(.primary(type: .button1SemiBold))
            ScooterBatteryView(batteryPercentage: scooterData.battery)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 20) {
                LeftSection(scooterData: scooterData)
                RightSection()
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 30)
    }
}

struct TripDetailsMinimisedView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                TripDetailsMinimisedView(scooterData: .mockedScooter())
                    .previewDevice(device)
            }
        }
    }
}
