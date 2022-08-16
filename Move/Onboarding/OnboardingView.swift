//
//  OnboardingCoordinatorView.swift
//  Move
//
//  Created by Daria Andrioaie on 09.08.2022.
//

import SwiftUI

struct SingleOnboardingView: View {
    let viewData: OnboardingStateData
    let totalNumberOfStates: Int
    let onNext: () -> Void
    let onSkip: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(viewData.imagePath)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.bottom, 0)
            HStack {
                Text(viewData.headline)
                    .font(.primary(type: .heading1))
                    .foregroundColor(.primaryBlue)
                Spacer()
                Button("Skip") {
                    onSkip()
                }
                .font(.primary(.semiBold, size: 14))
                .foregroundColor(.neutralPurple)
            }
            .padding([.leading, .trailing], 24)
            
            Text(viewData.description)
                .font(.primary(type: .body2))
                .foregroundColor(.primaryBlue)
                .frame(width: 283, alignment: .leading)
                .padding([.leading, .trailing], 24)
                .padding(.top, 12)
            Spacer()
            HStack {
                ForEach(0..<totalNumberOfStates, id: \.self) { index in
                    if index == viewData.orderNumber {
                        Capsule()
                            .frame(width: 16, height: 4)
                            .foregroundColor(.primaryBlue)
                            .padding(2)
                    }
                    else {
                        Capsule()
                            .frame(width: 4, height: 4)
                            .foregroundColor(.neutralPurple)
                            .padding(2)
                    }
                }
                Spacer()
                Button(action: {
                    onNext()
                }) {
                    HStack {
                        Text(viewData.orderNumber != totalNumberOfStates - 1 ? "Next" : "Get started")
                        Image(systemName: "arrow.right")
                    }
                    .padding([.leading, .trailing], 16)
                    .largeActiveButton()
                }
            }
            .padding([.leading, .trailing], 24)
            .padding(.bottom, 74)
        }
        .ignoresSafeArea()
    }
}

struct OnboardingStateData {
    let imagePath: String
    let headline: String
    let description: String
    let orderNumber: Int
}

enum OnboardingState: Equatable {
    static func == (lhs: OnboardingState, rhs: OnboardingState) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    case safety(OnboardingStateData)
    case scan(OnboardingStateData)
    case ride(OnboardingStateData)
    case parking(OnboardingStateData)
    case rules(OnboardingStateData)
    
    var identifier: String {
        switch self {
        case .safety: return "safety"
        case .scan: return "scan"
        case .ride: return "ride"
        case .parking: return "parking"
        case .rules: return "rules"
        }
    }
}

class OnboardingViewModel: ObservableObject {
    @Published var state: OnboardingState = .safety(.init(imagePath: "safety", headline: "Safety", description: "Please wear a helmet and protect yourself while riding.", orderNumber: 0))
    let totalNumberOfStates = 5
}

struct OnboardingView: View {
    @StateObject var viewModel = OnboardingViewModel()
    let onFinished: () -> Void
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .safety(let safetyData):
                SingleOnboardingView(viewData: safetyData, totalNumberOfStates: viewModel.totalNumberOfStates) {
                    viewModel.state = .scan(.init(imagePath: "scan", headline: "Scan", description: "Scan the QR code or NFC sticker on top of the scooter to unlock and ride.", orderNumber: 1))
                } onSkip: {
                    onFinished()
                }
            case .scan(let scanData):
                SingleOnboardingView(viewData: scanData, totalNumberOfStates: viewModel.totalNumberOfStates) {
                    viewModel.state = .ride(.init(imagePath: "ride", headline: "Ride", description: "Step on the scooter with one foot and kick off the ground. When the scooter starts to coast, push the right throttle to accelerate.", orderNumber: 2))
                } onSkip: {
                    onFinished()
                }
            case .ride(let rideData):
                SingleOnboardingView(viewData: rideData, totalNumberOfStates: viewModel.totalNumberOfStates) {
                    viewModel.state = .parking(.init(imagePath: "parking", headline: "Parking", description: "If convenient, park at a bike rack. If not, park close to the edge of the sidewalk closest to the street. Do not block sidewalks, doors or ramps.", orderNumber: 3))
                } onSkip: {
                    onFinished()
                }
            case .parking(let parkingData):
                SingleOnboardingView(viewData: parkingData, totalNumberOfStates: viewModel.totalNumberOfStates) {
                    viewModel.state = .rules(.init(imagePath: "rules", headline: "Rules", description: "You must be 18 years or and older with a valid driving licence to operate a scooter. Please follow all street signs, signals and markings, and obey local traffic laws.", orderNumber: 4))
                } onSkip: {
                    onFinished()
                }
            case .rules(let rulesData):
                SingleOnboardingView(viewData: rulesData, totalNumberOfStates: viewModel.totalNumberOfStates) {
                    onFinished()
                } onSkip: {
                    onFinished()
                }
            }
        }
        .animation(.easeOut, value: viewModel.state)
    }
}

struct OnboardingCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                OnboardingView(onFinished: {})
                    .previewDevice(device)
            }
        }
    }
}
