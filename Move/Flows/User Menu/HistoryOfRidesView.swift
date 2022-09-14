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
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("From")
            Text(source)
            Text("To")
            Text(destination)
        }
        .frame(width: UIScreen.main.bounds.width * 4/7, alignment: .leading)
        .padding(.leading, 20)
        .background(RoundedRectangle(cornerRadius: 29)
            .foregroundColor(.neutralPurple)
            .opacity(0.25))
    }
}

struct MetricsView: View {
    let travelTimeInSeconds: Int
    let distanceInKilometers: Double
    
    var travelTimeAsString: String {
        return "\(travelTimeInSeconds / 3600):\((travelTimeInSeconds % 3600) / 60) min"
    }
    
    
    var body: some View {
        VStack {
            Text("Travel time")
            Text(travelTimeAsString)
            Text("Distance")
            Text("\(distanceInKilometers.formatted()) km")
        }
    }
}

struct RideView: View {
    let rideData: Ride
    
    var body: some View {
        HStack {
            RouteView(source: rideData.source, destination: rideData.destination)
            MetricsView(travelTimeInSeconds: rideData.travelTimeInSeconds, distanceInKilometers: rideData.distanceInKilometers)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 29)
                .stroke(Color.primaryBlue, lineWidth: 1)
        }
        .padding(.horizontal, 24)
        
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
                VStack(spacing: 12) {
                    ForEach(rides) { ride in
                        RideView(rideData: ride)
                    }
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct HistoryOfRidesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                HistoryOfRidesView(rides: [.init(id: 1, source: "Medias", destination: "Cluj", travelTimeInSeconds: 1000, distanceInKilometers: 100)], onBack: {})
                    .previewDevice(device)
            }
        }
    }
}
