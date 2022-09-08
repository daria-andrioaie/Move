//
//  AddLicenseView.swift
//  Move
//
//  Created by Daria Andrioaie on 11.08.2022.
//

import SwiftUI
import VisionKit
import AVFoundation

struct AddLicenseView: View {
    let authenticationAPIService: AuthenticationAPIService
    let errorHandler: SwiftMessagesErrorHandler
    let onValidationInProgress: () -> Void
    let onValidationSuccessful: () -> Void
    let onBack: () -> Void

    @State private var actionSheetDisplayMode = SheetDisplayMode.none
    @StateObject private var viewModel: AddLicenseViewModel
    
    init(authenticationAPIService: AuthenticationAPIService, errorHandler: SwiftMessagesErrorHandler, onValidationInProgress: @escaping () -> Void, onValidationSuccessful: @escaping () -> Void, onBack: @escaping () -> Void) {
        self.authenticationAPIService = authenticationAPIService
        self.errorHandler = errorHandler
        self.onValidationInProgress = onValidationInProgress
        self.onValidationSuccessful = onValidationSuccessful
        self.onBack = onBack
        self._viewModel = StateObject(wrappedValue: AddLicenseViewModel(authenticationAPIService: authenticationAPIService, errorHandler: errorHandler, onValidationInProgress: onValidationInProgress, onValidationSuccessful: onValidationSuccessful))
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    HStack {
                        Button {
                            // TODO: add slide animation when returning to authentication screen
                            onBack()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.primaryPurple)
                                .padding(.horizontal, 24)
                        }
                        Spacer()
                        Text("Driving License")
                            .foregroundColor(.primaryPurple)
                            .font(.primary(type: .navbarTitle))
                        Spacer()
                        Button {} label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.primaryPurple)
                                .padding(.horizontal, 24)
                        }
                        .opacity(0)
                    }
                    .padding()
                    
                    Image("driving-license-scan")
                        .resizable()
                        .scaledToFill()
                        .clipped()

                    Text("Before you can start riding")
                        .font(.primary(type: .heading1))
                        .foregroundColor(Color("PrimaryBlue"))
                        .alignLeadingWithHorizontalPadding()
                    
                    Text("Please take a photo or upload the front side of your driving license so we can make sure that it is valid.")
                        .font(.primary(type: .body2))
                        .foregroundColor(Color("PrimaryBlue"))
                        .alignLeadingWithHorizontalPadding()
                        .padding(.top, 10)
                    
                    
                    FormButton(title: "Add driving license", isEnabled: true, action: {
                        actionSheetDisplayMode = .third
                    })
                    .padding(.top, 31)
                }
            }
            FlexibleSheet(sheetMode: $actionSheetDisplayMode) {
                VStack {
                    Button("Upload from gallery", action: {
                        actionSheetDisplayMode = .none
                        viewModel.showImagePicker = true
                    })
                    .frame(maxWidth: .infinity)
                    .lightActiveButton()
                    .padding(.horizontal, 24)
                    
                    Button("Take picture now", action: {
                        actionSheetDisplayMode = .none
                        viewModel.scanLicense()
                    })
                    .frame(maxWidth: .infinity)
                    .activeButton()
                    .padding(.horizontal, 24)
                }
            }
            .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                .onEnded{ value in
                    // swipe down gesture on the action sheet
                    if (-100...100).contains(value.translation.width) &&
                        (0...).contains(value.translation.height) {
                        actionSheetDisplayMode = .none
                    }
                })
        }
        .sheet(isPresented: $viewModel.showScanner) {
            ScannerView { result in
                viewModel.showScanner = false
                viewModel.onScanFinished(result: result)
            } didCancelScanning: {
                viewModel.showScanner = false
            }
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePickerView(image: $viewModel.inputImage)
        }
        .onChange(of: viewModel.inputImage) { _ in
//            viewModel.loadImage()
            viewModel.sendRequest()
        }
    }
}

struct AddLicenseView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                AddLicenseView(authenticationAPIService: AuthenticationAPIService(userDefaultsManager: UserDefaultsManager()), errorHandler: SwiftMessagesErrorHandler(), onValidationInProgress: {}, onValidationSuccessful: {}, onBack: {})
                    .previewDevice(device)
            }
        }
    }
}
