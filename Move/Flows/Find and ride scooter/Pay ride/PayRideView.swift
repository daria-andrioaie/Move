//
//  PayRideView.swift
//  Move
//
//  Created by Daria Andrioaie on 03.10.2022.
//

import SwiftUI

struct RouteSummaryView: View {
    let locationType: LocationType
    let address: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(locationType == .source ? "From" : "To")
                .font(.primary(type: .button2))
                .foregroundColor(.neutralCement)
            Text(address)
                .lineLimit(nil)
                .font(.primary(type: .button1))
                .foregroundColor(.primaryBlue)
                .frame(height: 40, alignment: .top)
        }
    }
}

struct TripMetricsSummaryView: View {
    let travelTime: Int
    let distance: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                GenericTravelMetricsTitle(metricsType: .time)
                HStack(alignment: .firstTextBaseline) {
                    Text(travelTime.convertToHoursAndMinutesFormat() + " min")
                        .font(.primary(type: .button1))
                        .foregroundColor(.primaryBlue)
                }
                .padding(.leading, 30)
            }
            .padding(.trailing, 50)
            VStack(alignment: .leading) {
                GenericTravelMetricsTitle(metricsType: .distance)
                HStack(alignment: .firstTextBaseline) {
                    Text(distance.convertToKilometersFormat() + " km")
                        .font(.primary(type: .button1))
                        .foregroundColor(.primaryBlue)
                }
                .padding(.leading, 30)
            }
            .padding(.trailing, 50)
        }
        .frame(maxWidth: .infinity)
    }
}

struct TripSourceAndDestinationView: View {
    let source: String
    let destination: String
    
    var body: some View {
        VStack(alignment: .leading) {
            RouteSummaryView(locationType: .source, address: source)
            RouteSummaryView(locationType: .destination, address: destination)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16)
            .foregroundColor(.neutralPurple)
            .opacity(0.15)
        )
    }
}


struct PayRideView: View {
    let onSuccessfullyPaidRide: () -> Void
    @StateObject var payRideViewModel = PayRideViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(buttonAction: nil, onButtonPressed: {}, headerTitle: "Trip Summary")
                .padding(.top, 18)
                .padding(.bottom, 40)
            Image(uiImage: payRideViewModel.getSnapshotOfRide())
                .padding(.bottom, 40)
            TripSourceAndDestinationView(source: payRideViewModel.rideData.startAddress ?? "no source", destination: payRideViewModel.rideData.endAddress ?? "no destination")
                .padding(.bottom, 36)
            TripMetricsSummaryView(travelTime: payRideViewModel.rideData.duration, distance: payRideViewModel.rideData.distance)
            Spacer()
            ApplePayButton {
                payRideViewModel.paymentSuccessfulAlertIsShowing = true
            } label: {
                HStack {
                    Text("Pay with")
                        .font(.primary(.semiBold, size: 20))
                    Image("appleLogo")
                    Text("Pay")
                        .font(.primary(.semiBold, size: 23))
                        .offset(x: -6)
                }
            }
        }
        .padding(.horizontal, 24)
        .alert(isPresented: $payRideViewModel.paymentSuccessfulAlertIsShowing) {
            Alert(title: Text("Payment was successful"), message: Text("You can find your receipt on your email"), dismissButton: .default(Text("OK"), action: {
                payRideViewModel.removeRideFromUserDefaults()
                onSuccessfullyPaidRide()
            }))
        }
    }
    
//    var mapSnapshot: some View {
//        ZStack {
//            Image("mapSnapshot")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .cornerRadius(29)
//            Text("No route yet. :(")
//                .font(.primary(type: .heading2))
//                .foregroundColor(.accentPink)
//        }
//    }
}

struct PayRideView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                PayRideView(onSuccessfullyPaidRide: {})
            }
        }
    }
}
