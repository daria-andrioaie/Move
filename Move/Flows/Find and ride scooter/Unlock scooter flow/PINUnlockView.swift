//
//  PINUnlockView.swift
//  Move
//
//  Created by Daria Andrioaie on 17.09.2022.
//

import SwiftUI

struct DigitField: View {
    @Binding var digit: String
    @FocusState var fieldIsFocused: Bool
    let whenFilled: () -> Void
    
    
    var body: some View {
        TextField("", text: $digit)
            .focused($fieldIsFocused)
            .keyboardType(.numberPad)
            .tint(.primaryBlue)
            .offset(x: 24)
            .foregroundColor(.primaryBlue)
            .font(.primary(type: .heading2))
            .background(RoundedRectangle(cornerRadius: 18)
                .frame(width: 52, height: 52, alignment: .center)
                .foregroundColor(fieldIsFocused || digit.count == 1 ? .white : .neutralPurple))
            .onChange(of: digit) { newValue in
                if newValue.count == 1 {
                    whenFilled()
                }
            }
            .onTapGesture {
                if digit.count == 1 {
                    digit = ""
                }
            }
    }
}

struct PINFieldsSequence: View {
    @Binding var finalValue: String
    
    @State private var digit1 = ""
    @State private var digit2 = ""
    @State private var digit3 = ""
    @State private var digit4 = ""

    @FocusState var fieldOneIsFocused: Bool
    @FocusState var fieldTwoIsFocused: Bool
    @FocusState var fieldThreeIsFocused: Bool
    @FocusState var fieldFourIsFocused: Bool
        
    var body: some View {
        HStack(spacing: 16) {
            DigitField(digit: $digit1, fieldIsFocused: _fieldOneIsFocused) {
                fieldTwoIsFocused = true
            }
            DigitField(digit: $digit2, fieldIsFocused: _fieldTwoIsFocused) {
                fieldThreeIsFocused = true
            }
            DigitField(digit: $digit3, fieldIsFocused: _fieldThreeIsFocused) {
                fieldFourIsFocused = true
            }
            DigitField(digit: $digit4, fieldIsFocused: _fieldFourIsFocused) {
                fieldFourIsFocused = false
                finalValue = digit1 + digit2 + digit3 + digit4
            }
        }
        .padding(.horizontal, 60)
    }
}

struct PINUnlockView: View {
    @State private var isUnlockInProgress: Bool = false
    @State private var pin: String = ""

    let onCancelUnlock: () -> Void
    let onUnlockSuccessful: () -> Void
    let onSwitchToNFC: () -> Void
    let onSwitchToQR: () -> Void

    @ObservedObject var viewModel: UnlockViewModel

    var body: some View {
        ZStack {
            PurpleBackgroundView()
            VStack {
                UnlockHeaderView(headerTitle: "Enter serial number", showLightbulb: false, onCancelUnlock: onCancelUnlock)
                
                Text("Enter the scooter's serial number")
                    .multilineTextAlignment(.center)
                    .font(.primary(type: .heading1))
                    .foregroundColor(.white)
                    .padding(.top, 55)
                Text("You can find it on the \nscooter’s front panel")
                    .multilineTextAlignment(.center)
                    .font(.primary(type: .body1))
                    .opacity(0.7)
                    .foregroundColor(.white)
                    .padding(.top, 16)
                    .padding(.bottom, 104)

                if isUnlockInProgress {
                    ActivityIndicator()
                        .frame(width: 50, height: 50)
                        .padding(.bottom, 155)
                }
                else {
                    PINFieldsSequence(finalValue: $pin)
                        .onChange(of: pin) { newPin in
                            if newPin.count == 4 {
                                self.isUnlockInProgress = true
                                viewModel.sendUnlockRequest(scooterNumber: newPin) {
                                    onUnlockSuccessful()
                                } onAPIError: { error in
                                    isUnlockInProgress = false
                                    let errorHandler = SwiftMessagesErrorHandler()
                                    errorHandler.handle(message: error.message, type: .error)
                                }
                            }
                        }
                        .padding(.bottom, 155)
                }
                AlternativeUnlockOptionsView(alternative1: "QR", onAlternaive1: {
                    onSwitchToQR()
                }, alternative2: "NFC") {
                    onSwitchToNFC()
                }
                
                Spacer()

            }
            .frame(maxHeight: .infinity)
        }
    }
}

struct PINUnlockView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                PINUnlockView(onCancelUnlock: {}, onUnlockSuccessful: {}, onSwitchToNFC: {}, onSwitchToQR: {}, viewModel: UnlockViewModel())
                    .previewDevice(device)
            }
        }
    }
}
