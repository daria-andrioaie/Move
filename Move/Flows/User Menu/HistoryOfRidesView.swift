//
//  HistoryOfRidesView.swift
//  Move
//
//  Created by Daria Andrioaie on 14.09.2022.
//

import SwiftUI

struct RouteView: View {
    let source: String
    let destination: String
//    let geometry: GeometryProxy
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("From")
                .font(.primary(type: .smallText))
                .foregroundColor(.neutralCement)
            Text(source)
                .lineLimit(nil)
                .font(.primary(type: .boldedDetails))
                .foregroundColor(.primaryBlue)
                .frame(height: 40, alignment: .top)
            Text("To")
                .font(.primary(type: .smallText))
                .foregroundColor(.neutralCement)
            Text(destination)
                .lineLimit(nil)
                .font(.primary(type: .boldedDetails))
                .foregroundColor(.primaryBlue)
                .frame(height: 40, alignment: .top)

        }
//        .frame(width: geometry.size.width * 4 / 7, alignment: .leading)
        .frame(width: UIScreen.main.bounds.width * 3/7, alignment: .leading)
        .padding(.leading, 20)
        .padding(.vertical,  20)
        .background(RoundedRectangle(cornerRadius: 29)
            .foregroundColor(.neutralPurple)
            .opacity(0.20))
    }
}

struct MetricsView: View {
    let travelTimeInSeconds: Int
    let distanceInMeters: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Travel time")
                .font(.primary(type: .smallText))
                .foregroundColor(.neutralCement)
            Text(travelTimeInSeconds.convertToHoursAndMinutesFormat() + " min")
                .font(.primary(type: .boldedDetails))
                .foregroundColor(.primaryBlue)
            Text("Distance")
                .font(.primary(type: .smallText))
                .foregroundColor(.neutralCement)
            Text("\(distanceInMeters.formatted()) km")
                .font(.primary(type: .boldedDetails))
                .foregroundColor(.primaryBlue)
        }
        .padding(.vertical,  20)
    }
}

struct RideView: View {
    let rideData: Ride
    
    var body: some View {
//        GeometryReader { geometry in
            HStack {
                RouteView(source: rideData.source, destination: rideData.destination)
                
                MetricsView(travelTimeInSeconds: rideData.travelTimeInSeconds, distanceInMeters: rideData.distanceInMeters)
            }
            .frame(maxWidth: .infinity)
            .overlay {
                RoundedRectangle(cornerRadius: 29)
                    .stroke(Color.primaryBlue, lineWidth: 1)
            }
//        }
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
//                    List {
//                        ForEach(rides) { ride in
////                                Text("alalalala")
//                            RideView(rideData: ride)
//                        }
//                    }
                    VStack(spacing: 12) {
                        ForEach(rides) { ride in
//                                Text("alalalala")
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
                HistoryOfRidesView(rides: [.init(id: 1, source: "9776 Gutkowski Shores Suite 420", destination: "980 Scarlett Brook Apt. 233", travelTimeInSeconds: 1000, distanceInMeters: 100)
                    , .init(id: 2, source: "256 Osvaldo Camp", destination: "06 Gerhold Valleys", travelTimeInSeconds: 765, distanceInMeters: 12.3)
//                                           , .init(id: 3, source: "267 Quitzon Gateway", destination: "980 Scarlett Brook Apt. 233", travelTimeInSeconds: 345, distanceInKilometers: 7.0)
                                          ], onBack: {})
                    .previewDevice(device)
            }
        }
    }
}
