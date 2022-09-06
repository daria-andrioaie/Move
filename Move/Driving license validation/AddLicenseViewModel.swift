//
//  AddLicenseViewModel.swift
//  Move
//
//  Created by Daria Andrioaie on 06.09.2022.
//

import Foundation
import SwiftUI
import VisionKit
import AVFoundation

class AddLicenseViewModel: ObservableObject {
    @Published var showScanner = false
    @Published var deniedCameraAccess = false
    
    @Published var showImagePicker = false
//    @Published var image: Image?
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
                else {
//                    self.errorHandler.handle(message: "To scan your license, you need to allow Move to use your camera.", type: .warning)
                    self.errorHandler.handle(message: "To scan your license, you need to allow Move to use your camera.", buttonLabel: "Go to settings", type: .warning, onScreenDuration: 4) {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                }
            }
        case .denied:
            self.deniedCameraAccess = true
            self.errorHandler.handle(message: "To scan your license, you need to allow Move to use your camera.", buttonLabel: "Go to settings", type: .warning, onScreenDuration: 4) {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            
        case .restricted:
            //TODO: how do you handle this case?
            return
            
        @unknown default:
            return
        }
    }
    
    func onScanFinished(result: Result<UIImage, Error>) {
        switch result {
        case .success(let scannedImage):
            inputImage = scannedImage
            sendRequest()
        case .failure(let error):
            errorHandler.handle(message: error.localizedDescription, type: .error)
        }
    }
    
    func sendRequest() {
        guard let inputImage = inputImage else {
            errorHandler.handle(message: "No image selected", type: .error)
            return
        }
        
        guard let userToken = try? userDefaultsManager.getUserToken() else {
            errorHandler.handle(message: "Can't find token in User Defaults!", type: .error)
            return
        }
        
        print("Request in progress..")
        self.onValidationInProgress()
        
        AuthenticationAPIService.uploadDrivingLicenseRequest(image: inputImage, userToken: userToken, onRequestCompleted: { result in
            switch result {
            case .success(let user):
                try? self.userDefaultsManager.saveUser(user)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    print("Request finished")
                    self.onValidationSuccessful()
                })
            case .failure(let apiError):
                self.errorHandler.handle(message: apiError.message, type: .error)
            }
        })
    }
}
