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
        GeometryReader { geometry in
            VStack() {
                Image(viewData.imagePath)
                    .resizable()
                    .scaledToFill()
//                    .frame(height: geometry.size.height * 8/10)
                    .frame(height: UIScreen.main.bounds.height * 5.5/10)
                    .clipped()
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
                .padding(.horizontal, 24)
                
                Text(viewData.description)
                    .font(.primary(type: .body2))
                    .foregroundColor(.primaryBlue)
                    .padding(.top, 12)
                    .alignLeadingWithHorizontalPadding()
                    
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
                        .padding(.horizontal, 16)
                        .largeActiveButton()
                    }
                }
                .padding(.horizontal, 24)
                Spacer()
            }
            .ignoresSafeArea()
        }
    }
}

struct OnboardingStateData {
    let imagePath: String
    let headline: String
    let description: String
    let orderNumber: Int
}

//enum OnboardingState: Equatable {
//    static func == (lhs: OnboardingState, rhs: OnboardingState) -> Bool {
//        return lhs.identifier == rhs.identifier
//    }
//
//    case safety(OnboardingStateData)
//    case scan(OnboardingStateData)
//    case ride(OnboardingStateData)
//    case parking(OnboardingStateData)
//    case rules(OnboardingStateData)
//
//    var identifier: String {
//        switch self {
//        case .safety: return "safety"
//        case .scan: return "scan"
//        case .ride: return "ride"
//        case .parking: return "parking"
//        case .rules: return "rules"
//        }
//    }
//}

enum OnboardingState: Equatable {
    static func == (lhs: OnboardingState, rhs: OnboardingState) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    case safety
    case scan
    case ride
    case parking
    case rules
    
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
//    @Published var state: OnboardingState = .safety(.init(imagePath: "safety", headline: "Safety", description: "Please wear a helmet and protect yourself while riding.", orderNumber: 0))
    let totalNumberOfStates = 5
//
    
//    @Published var state3 = OnboardingState3.safety
//    let states = ["safety" : OnboardingStateData(imagePath: "safety", headline: "Safety", description: "Please wear a helmet and protect yourself while riding.", orderNumber: 0)
//    ]
    
    @Published var state: OnboardingState? = .safety
    
    func getSafetyData() -> OnboardingStateData {
        OnboardingStateData(imagePath: "safety", headline: "Safety", description: "Please wear a helmet and protect yourself while riding.", orderNumber: 0)
    }
    
    func getScanData() -> OnboardingStateData {
        OnboardingStateData(imagePath: "scan", headline: "Scan", description: "Scan the QR code or NFC sticker on top of the scooter to unlock and ride.", orderNumber: 1)
    }
    
    func getRideData() -> OnboardingStateData {
        OnboardingStateData(imagePath: "ride", headline: "Ride", description: "Step on the scooter with one foot and kick off the ground. When the scooter starts to coast, push the right throttle to accelerate.", orderNumber: 2)
    }
    
    func getParkingData() -> OnboardingStateData {
        OnboardingStateData(imagePath: "parking", headline: "Parking", description: "If convenient, park at a bike rack. If not, park close to the edge of the sidewalk closest to the street. Do not block sidewalks, doors or ramps.", orderNumber: 3)
    }
    
    func getRulesData() -> OnboardingStateData {
        OnboardingStateData(imagePath: "rules", headline: "Rules", description: "You must be 18 years or and older with a valid driving licence to operate a scooter. Please follow all street signs, signals and markings, and obey local traffic laws.", orderNumber: 4)
    }
}

struct OnboardingView: View {
    @StateObject var viewModel = OnboardingViewModel()
    let onFinished: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: SingleOnboardingView(viewData: viewModel.getSafetyData(), totalNumberOfStates: viewModel.totalNumberOfStates, onNext: {
                        viewModel.state = .scan
                }, onSkip: {
                    onFinished()
                })
                    .transition(.opacity.animation(.default))
                    .navigationBarBackButtonHidden(true), tag: .safety, selection: $viewModel.state, label: {
                    EmptyView()
                })
                
                NavigationLink(destination: SingleOnboardingView(viewData: viewModel.getScanData(), totalNumberOfStates: viewModel.totalNumberOfStates, onNext: {
                        viewModel.state = .ride
                }, onSkip: {
                    onFinished()
                })
                    .transition(.opacity.animation(.default))
                    .navigationBarBackButtonHidden(true), tag: .scan, selection: $viewModel.state) {
                    EmptyView()
                }
                .transition(.move(edge: .trailing))
//                .animation(.easeOut, value: viewModel.state)
                
                NavigationLink(destination: SingleOnboardingView(viewData: viewModel.getRideData(), totalNumberOfStates: viewModel.totalNumberOfStates, onNext: {
                    withAnimation {
                        viewModel.state = .parking
                    }
                }, onSkip: {
                    onFinished()
                })
                    .transition(.opacity.animation(.default))
                    .navigationBarBackButtonHidden(true), tag: .ride, selection: $viewModel.state) {
                    EmptyView()
                }
                
                NavigationLink(destination: SingleOnboardingView(viewData: viewModel.getParkingData(), totalNumberOfStates: viewModel.totalNumberOfStates, onNext: {
                    withAnimation {
                        viewModel.state = .rules
                    }
                }, onSkip: {
                    onFinished()
                })
                    .transition(.opacity.animation(.default))
                    .navigationBarBackButtonHidden(true), tag: .parking, selection: $viewModel.state) {
                    EmptyView()
                }
                
                NavigationLink(destination: SingleOnboardingView(viewData: viewModel.getRulesData(), totalNumberOfStates: viewModel.totalNumberOfStates, onNext: {
                    withAnimation {
                        onFinished()
                    }
                }, onSkip: {
                    onFinished()
                })
                    .transition(.opacity.animation(.default))
                    .navigationBarBackButtonHidden(true), tag: .rules, selection: $viewModel.state) {
                    EmptyView()
                }
            }
        }
        
    
//        ZStack {
//            switch viewModel.state {
//            case .safety(let safetyData):
//                SingleOnboardingView(viewData: safetyData, totalNumberOfStates: viewModel.totalNumberOfStates) {
//                    viewModel.state = .scan(.init(imagePath: "scan", headline: "Scan", description: "Scan the QR code or NFC sticker on top of the scooter to unlock and ride.", orderNumber: 1))
//                } onSkip: {
//                    onFinished()
//                }
//            case .scan(let scanData):
//                SingleOnboardingView(viewData: scanData, totalNumberOfStates: viewModel.totalNumberOfStates) {
//                    viewModel.state = .ride(.init(imagePath: "ride", headline: "Ride", description: "Step on the scooter with one foot and kick off the ground. When the scooter starts to coast, push the right throttle to accelerate.", orderNumber: 2))
//                } onSkip: {
//                    onFinished()
//                }
//            case .ride(let rideData):
//                SingleOnboardingView(viewData: rideData, totalNumberOfStates: viewModel.totalNumberOfStates) {
//                    viewModel.state = .parking(.init(imagePath: "parking", headline: "Parking", description: "If convenient, park at a bike rack. If not, park close to the edge of the sidewalk closest to the street. Do not block sidewalks, doors or ramps.", orderNumber: 3))
//                } onSkip: {
//                    onFinished()
//                }
//            case .parking(let parkingData):
//                SingleOnboardingView(viewData: parkingData, totalNumberOfStates: viewModel.totalNumberOfStates) {
//                    viewModel.state = .rules(.init(imagePath: "rules", headline: "Rules", description: "You must be 18 years or and older with a valid driving licence to operate a scooter. Please follow all street signs, signals and markings, and obey local traffic laws.", orderNumber: 4))
//                } onSkip: {
//                    onFinished()
//                }
//            case .rules(let rulesData):
//                SingleOnboardingView(viewData: rulesData, totalNumberOfStates: viewModel.totalNumberOfStates) {
//                    onFinished()
//                } onSkip: {
//                    onFinished()
//                }
//            }
//        }
//        .animation(.easeOut, value: viewModel.state)
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