//
//  OnboardingCoordinatorView.swift
//  Move
//
//  Created by Daria Andrioaie on 09.08.2022.
//

import SwiftUI

struct SingleOnboardingView: View {
    let viewData: OnboardingStateData
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
                    .font(.custom("BaiJamjuree-Bold", size: 32))
                    .foregroundColor(Color("PrimaryBlue"))
                Spacer()
                Button("Skip") {
                    onSkip()
                }
                    .font(.custom("BaiJamjuree-SemiBold", size: 14))
                    .foregroundColor(Color("NeutralCement"))
            }
            .padding([.leading, .trailing], 24)
            
            Text(viewData.description)
                .font(.custom("BaiJamjuree-Light", size: 16))
                .foregroundColor(Color("PrimaryBlue"))
                .frame(width: 283, alignment: .leading)
                .padding([.leading, .trailing], 24)
                .padding(.top, 12)
            Spacer()
            HStack {
                Text("progress bar")
                Spacer()
                Button(action: {
                    onNext()
                }) {
                    HStack {
                        Text("Next")
                            .font(.custom("BaiJamjuree-Bold", size: 16))
                        Image(systemName: "arrow.right")
                    }
                        .foregroundColor(.white)
                        .frame(width: 100, height: 56)
                        .background(RoundedRectangle(cornerRadius: 17)
                            .fill(Color("AccentPink")))
                }
            }
            .padding([.leading, .trailing], 24)
            .padding(.bottom, 74)
        }
        .ignoresSafeArea()
    }
}

struct OnboardingStateData {
    var imagePath: String
    var headline: String
    var description: String
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
    case finished
    
    var identifier: String {
        switch self {
        case .safety: return "safety"
        case .scan: return "scan"
        case .ride: return "ride"
        case .parking: return "parking"
        case .rules: return "rules"
        case .finished: return "finished"
        }
    }
}

class OnboardingViewModel: ObservableObject {
    @Published var state: OnboardingState = .safety(.init(imagePath: "safety", headline: "Safety", description: "Please wear a helmet and protect yourself while riding"))
}

struct OnboardingCoordinatorView: View {
    @StateObject var viewModel = OnboardingViewModel()
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .safety(let safetyData):
                SingleOnboardingView(viewData: safetyData) {
                    viewModel.state = .scan(.init(imagePath: "scan", headline: "Scan", description: "Scan the QR code or NFC sticker on top of the scooter to unlock and ride."))
                } onSkip: {
                    viewModel.state = .finished
                }
            case .scan(let scanData):
                SingleOnboardingView(viewData: scanData) {
                    viewModel.state = .ride(.init(imagePath: "ride", headline: "Ride", description: "Step on the scooter with one foot and kick off the ground. When the scooter starts to coast, push the right throttle to accelerate."))
                } onSkip: {
                    viewModel.state = .finished
                }
            case .ride(let rideData):
                SingleOnboardingView(viewData: rideData) {
                    viewModel.state = .parking(.init(imagePath: "parking", headline: "Parking", description: "If convenient, park at a bike rack. If not, park close to the edge of the sidewalk closest to the street. Do not block sidewalks, doors or ramps."))
                } onSkip: {
                    viewModel.state = .finished
                }
            case .parking(let parkingData):
                SingleOnboardingView(viewData: parkingData) {
                    viewModel.state = .rules(.init(imagePath: "rules", headline: "Rules", description: "You must be 18 years or and older with a valid driving licence to operate a scooter. Please follow all street signs, signals and markings, and obey local traffic laws."))
                } onSkip: {
                    viewModel.state = .finished
                }
            case .rules(let rulesData):
                SingleOnboardingView(viewData: rulesData) {
                    viewModel.state = .finished
                } onSkip: {
                    viewModel.state = .finished
                }
            case .finished:
                ZStack {
                    Color("AccentPink")
                    Text("Finished onboarding")
                        .foregroundColor(.white)
                }
            }
        }
        .animation(.easeOut, value: viewModel.state)
    }
}

struct OnboardingCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCoordinatorView()
    }
}
