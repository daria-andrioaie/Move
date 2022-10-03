//
//  HistoryOfRidesView.swift
//  Move
//
//  Created by Daria Andrioaie on 14.09.2022.
//

import SwiftUI

enum LocationType {
    case source
    case destination
}

struct RouteView: View {
    let locationType: LocationType
    let address: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(locationType == .source ? "From" : "To")
                .font(.primary(type: .smallText))
                .foregroundColor(.neutralCement)
            Text(address)
                .lineLimit(nil)
                .font(.primary(type: .boldedDetails))
                .foregroundColor(.primaryBlue)
                .frame(height: 40, alignment: .top)
        }
        .frame(width: UIScreen.main.bounds.width * 3/7, alignment: .leading)
//        .padding(.leading, 20)
//        .padding(.vertical,  20)
//        .background(RoundedRectangle(cornerRadius: 29)
//            .foregroundColor(.neutralPurple)
//            .opacity(0.20))
    }
}

struct RideHistoryTravelMetricsView: View {
    let metricsType: MetricsType
    let metricsValue: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(metricsType == .time ? "Travel time" : "Distance")
                .font(.primary(type: .smallText))
                .foregroundColor(.neutralCement)
            HStack(alignment: .firstTextBaseline) {
                Text(metricsType == .time ? metricsValue.convertToHoursAndMinutesFormat() + " min" : metricsValue.convertToKilometersFormat() + " km")
                    .font(.primary(type: .boldedDetails))
                    .foregroundColor(.primaryBlue)
            }
        }
    }
}

struct RideView: View {
    let rideData: Ride
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                RouteView(locationType: .source, address: rideData.source ?? "no source address")
                Spacer()
                RideHistoryTravelMetricsView(metricsType: .time, metricsValue: rideData.duration)
            }
            HStack(alignment: .top) {
                RouteView(locationType: .destination, address: rideData.destination ?? "no destination address")
                Spacer()
                RideHistoryTravelMetricsView(metricsType: .distance, metricsValue: rideData.distance)
                    .padding(.trailing, 18)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .background(RoundedRectangle(cornerRadius: 29)
            .foregroundColor(.neutralPurple)
            .opacity(0.20)
            .padding(.trailing, 109)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 29)
                .stroke(Color.primaryBlue, lineWidth: 1)
        }
    }
}

struct HistoryOfRidesView: View {
    let rides: [Ride]
    let onBack: () -> Void
    var body: some View {
        VStack {
            HeaderView(buttonAction: .slideBack, onButtonPressed: onBack, headerTitle: "History")
            if rides.count == 0 {
                Text("You have no rides yet. :(")
                    .frame(maxHeight: .infinity, alignment: .center)
                    .font(.primary(type: .heading2))
                    .foregroundColor(.primaryPurple)
            }
            else {
                ScrollView(.vertical) {
                    VStack(spacing: 12) {
                        ForEach(rides, id: \.self) { ride in
                            RideView(rideData: ride)
                        }
                    }
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, 24)
    }
}

struct HistoryOfRidesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                HistoryOfRidesView(rides: [.init(_id: "1", scooterNumber: 2455, startMode: "PIN", userId: "alalalidbn", source: "9776 Gutkowski Shores Suite 420", destination: "980 Scarlett Brook Apt. 233", duration: 1000, startTime: 0, endTime: 10, distance: 100, price: 12, status: "completed"),
                                           .init(_id: "2", scooterNumber: 1234, startMode: "QR", userId: "dhedd", source: "256 Osvaldo Camp", destination: "06 Gerhold Valleys", duration: 765, startTime: 1, endTime: 10, distance: 7200, price: 300, status: "completed")], onBack: {})
                    .previewDevice(device)
            }
        }
    }
}
