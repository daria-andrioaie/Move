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
        VStack(alignment: .leading, spacing: 0) {
            Text(locationType == .source ? "From" : "To")
                .font(.primary(type: .smallText))
                .foregroundColor(.neutralCement)
            Text(address)
                .lineLimit(nil)
                .font(.primary(type: .boldedDetails))
                .foregroundColor(.primaryBlue)
                .frame(height: 40, alignment: .top)
        }
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
                RouteView(locationType: .source, address: rideData.startAddress ?? "no source address")
                    .frame(width: UIScreen.main.bounds.width * 3/7, alignment: .leading)
                Spacer()
                RideHistoryTravelMetricsView(metricsType: .time, metricsValue: rideData.duration)
            }
            HStack(alignment: .top) {
                RouteView(locationType: .destination, address: rideData.endAddress ?? "no destination address")
                    .frame(width: UIScreen.main.bounds.width * 3/7, alignment: .leading)
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

struct RidesScrollView: View {
    let rides: [Ride]
    
    var body: some View {
        if rides.count == 0 {
            Text("You have no rides yet. :(")
                .frame(maxHeight: .infinity, alignment: .center)
                .font(.primary(type: .heading2))
                .foregroundColor(.primaryBlue)
        }
        else {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(rides, id: \.self) { ride in
                        RideView(rideData: ride)
                    }
                }
            }
        }
    }
}

struct HistoryOfRidesView: View {
    @StateObject var viewModel: HistoryOfRidesViewModel = .init()
    
    let onBack: () -> Void
    var body: some View {
        VStack {
            HeaderView(buttonAction: .slideBack, onButtonPressed: onBack, headerTitle: "History")
            
            if viewModel.requestInProgress {
                ActivityIndicator()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.primaryPurple)
                    .frame(maxHeight: .infinity, alignment: .center)
            }
            else {
                RidesScrollView(rides: viewModel.rides ?? [])
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
                HistoryOfRidesView(onBack: {})
                    .previewDevice(device)
            }
        }
    }
}
