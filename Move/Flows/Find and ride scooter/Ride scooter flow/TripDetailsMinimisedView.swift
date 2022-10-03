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
    let timeInSeconds: Int
    let onLockUnlock: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            GenericTravelMetricsView(metricsType: .time, metricsValue: timeInSeconds)
            
            LockUnlockButton(scooterLockStatus: scooterData.lockedStatus, onLockUnlock: onLockUnlock)
        }
    }
}

struct RightSection: View {
    let distanceInMeters: Int
    let onEndRide: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            GenericTravelMetricsView(metricsType: .distance, metricsValue: distanceInMeters)
            EndRideButton(onEndRide: onEndRide)
        }
    }
}

struct TripDetailsMinimisedView: View {
    var scooterData: ScooterData
    let timeInSeconds: Int
    let distanceInMeters: Int
    let onLockUnlock: () -> Void
    let onEndRide: () -> Void
    
    var body: some View {
        VStack(spacing: 25) {
            Text("Trip details")
                .foregroundColor(.primaryBlue)
                .font(.primary(type: .button1SemiBold))
            ScooterBatteryView(batteryPercentage: scooterData.battery)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 20) {
                LeftSection(scooterData: scooterData, timeInSeconds: timeInSeconds, onLockUnlock: onLockUnlock)
                RightSection(distanceInMeters: distanceInMeters, onEndRide: onEndRide)
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
                TripDetailsMinimisedView(scooterData: .mockedScooter(), timeInSeconds: 720, distanceInMeters: 2700, onLockUnlock: {}, onEndRide: {})
                    .previewDevice(device)
            }
        }
    }
}
