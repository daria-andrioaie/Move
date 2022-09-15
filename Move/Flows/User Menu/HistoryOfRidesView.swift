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
    let geometry: GeometryProxy
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("From")
                .font(.primary(type: .smallText))
                .foregroundColor(.neutralCement)
            Text(source)
                .lineLimit(nil)
                .font(.primary(type: .boldedDetails))
                .foregroundColor(.primaryBlue)
            Text("To")
                .font(.primary(type: .smallText))
                .foregroundColor(.neutralCement)
            Text(destination)
                .lineLimit(nil)
                .font(.primary(type: .boldedDetails))
                .foregroundColor(.primaryBlue)
        }
        .frame(width: geometry.size.width * 4 / 7, alignment: .leading)
        .padding(.leading, 20)
        .padding(.vertical,  20)
        .background(RoundedRectangle(cornerRadius: 29)
            .foregroundColor(.neutralPurple)
            .opacity(0.20))
    }
}

struct MetricsView: View {
    let travelTimeInSeconds: Int
    let distanceInKilometers: Double
    
    var travelTimeAsString: String {
        let hour: String
        if (travelTimeInSeconds / 3600) / 10 == 0 {
            hour = "0\((travelTimeInSeconds / 3600))"
        }
        else {
            hour = "\((travelTimeInSeconds / 3600))"
        }
        
        let minute: String
        if ((travelTimeInSeconds % 3600) / 60) / 10 == 0 {
            minute = "0\((travelTimeInSeconds % 3600) / 60)"
        }
        else {
            minute = "\((travelTimeInSeconds % 3600) / 60)"
        }
        
        return "\(hour):\(minute) min"
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Travel time")
                .font(.primary(type: .smallText))
                .foregroundColor(.neutralCement)
            Text(travelTimeAsString)
                .font(.primary(type: .boldedDetails))
                .foregroundColor(.primaryBlue)
            Text("Distance")
                .font(.primary(type: .smallText))
                .foregroundColor(.neutralCement)
            Text("\(distanceInKilometers.formatted()) km")
                .font(.primary(type: .boldedDetails))
                .foregroundColor(.primaryBlue)
        }
        .padding(.vertical,  20)
    }
}

struct RideView: View {
    let rideData: Ride
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                RouteView(source: rideData.source, destination: rideData.destination, geometry: geometry)
                
                MetricsView(travelTimeInSeconds: rideData.travelTimeInSeconds, distanceInKilometers: rideData.distanceInKilometers)
            }
            .frame(maxWidth: .infinity)
            .overlay {
                RoundedRectangle(cornerRadius: 29)
                    .stroke(Color.primaryBlue, lineWidth: 1)
            }
        }
    }
}

struct HistoryOfRidesView: View {
    let rides: [Ride]
    let onBack: () -> Void
    var body: some View {
        VStack {
            HeaderView(onBack: onBack, headerTitle: "History")
            if rides.count == 0 {
                Text("You have no rides yet. :(")
                    .frame(maxHeight: .infinity, alignment: .center)
                    .font(.primary(type: .heading2))
                    .foregroundColor(.primaryPurple)
            }
            else {
                ScrollView(.vertical) {
                    VStack(spacing: 12) {
                        ForEach(rides) { ride in
    //                            Text("alalalala")
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
                HistoryOfRidesView(rides: [.init(id: 1, source: "9776 Gutkowski Shores Suite 420", destination: "980 Scarlett Brook Apt. 233", travelTimeInSeconds: 1000, distanceInKilometers: 100)
//                                           , .init(id: 2, source: "256 Osvaldo Camp", destination: "06 Gerhold Valleys", travelTimeInSeconds: 765, distanceInKilometers: 12.3), .init(id: 3, source: "267 Quitzon Gateway", destination: "980 Scarlett Brook Apt. 233", travelTimeInSeconds: 345, distanceInKilometers: 7.0)
                                          ], onBack: {})
                    .previewDevice(device)
            }
        }
    }
}
