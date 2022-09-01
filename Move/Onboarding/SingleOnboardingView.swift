//
//  SingleOnboardingView.swift
//  Move
//
//  Created by Daria Andrioaie on 01.09.2022.
//

import Foundation
import SwiftUI

struct SingleOnboardingView: View {
    let viewData: OnboardingData
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
            .background(.white)
        }
    }
}
