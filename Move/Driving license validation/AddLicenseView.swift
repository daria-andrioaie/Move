//
//  AddLicenseView.swift
//  Move
//
//  Created by Daria Andrioaie on 11.08.2022.
//

import SwiftUI
import VisionKit
import AVFoundation

class AddLicenseViewModel: ObservableObject {
    @Published var showScanner = false
    @Published var deniedCameraAccess = false
    
    @Published var showImagePicker = false
    @Published var image: Image?
    @Published var inputImage: UIImage?
    
    let userDefaultsManager: UserDefaultsManager
    let errorHandler: SwiftMessagesErrorHandler
    let onValidationInProgress: () -> Void
    let onValidationSuccessful: () -> Void
    
    init(userDefaultsManager: UserDefaultsManager, errorHandler: SwiftMessagesErrorHandler, onValidationInProgress: @escaping () -> Void, onValidationSuccessful: @escaping () -> Void) {
        self.userDefaultsManager = userDefaultsManager
        self.errorHandler = errorHandler
        self.onValidationInProgress = onValidationInProgress
        self.onValidationSuccessful = onValidationSuccessful
    }
    
    func scanLicense() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            showScanner = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { accessGranted in
                if accessGranted {
                    self.showScanner = true
                }
            }
        case .denied:
            self.deniedCameraAccess = true
            
        case .restricted:
            return
            
        @unknown default:
            return
        }
    }
    
    func onScanFinished(result: Result<UIImage, Error>) {
        switch result {
        case .success(let scannedImage):
            image = Image(uiImage: scannedImage)
            sendRequest()
        case .failure(let error):
            errorHandler.handle(message: error.localizedDescription, type: .error)
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else {
            return
        }
        image = Image(uiImage: inputImage)
        sendRequest()
    }
    
    func sendRequest() {
        if let image = image {
            print("Request in progress..")
            self.onValidationInProgress()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                print("Request finished")
                self.onValidationSuccessful()
            })
        }
        else {
            errorHandler.handle(message: "No image selected", type: .error)
        }
    }
}

struct AddLicenseView: View {
    let userDefaultsManager: UserDefaultsManager
    let errorHandler: SwiftMessagesErrorHandler
    let onValidationInProgress: () -> Void
    let onValidationSuccessful: () -> Void
    let onBack: () -> Void

    @State private var actionSheetDisplayMode = SheetDisplayMode.none
    @StateObject private var viewModel: AddLicenseViewModel
    
    init(userDefaultsManager: UserDefaultsManager, errorHandler: SwiftMessagesErrorHandler, onValidationInProgress: @escaping () -> Void, onValidationSuccessful: @escaping () -> Void, onBack: @escaping () -> Void) {
        self.userDefaultsManager = userDefaultsManager
        self.errorHandler = errorHandler
        self.onValidationInProgress = onValidationInProgress
        self.onValidationSuccessful = onValidationSuccessful
        self.onBack = onBack
        self._viewModel = StateObject(wrappedValue: AddLicenseViewModel(userDefaultsManager: userDefaultsManager, errorHandler: errorHandler, onValidationInProgress: onValidationInProgress, onValidationSuccessful: onValidationSuccessful))
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
            viewModel.loadImage()
        }
    }
}

struct AddLicenseView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                AddLicenseView(userDefaultsManager: UserDefaultsManager(), errorHandler: SwiftMessagesErrorHandler(), onValidationInProgress: {}, onValidationSuccessful: {}, onBack: {})
                    .previewDevice(device)
            }
        }
    }
}
