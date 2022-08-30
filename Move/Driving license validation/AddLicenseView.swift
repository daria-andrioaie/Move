//
//  AddLicenseView.swift
//  Move
//
//  Created by Daria Andrioaie on 11.08.2022.
//

import SwiftUI
import VisionKit
import AVFoundation

enum SheetMode {
    case none
    case third
}

struct FlexibleSheet<Content: View>: View {
    
    let content: () -> Content
    var sheetMode: Binding<SheetMode>
    
    init(sheetMode: Binding<SheetMode>, @ViewBuilder content: @escaping () -> Content) {
        self.sheetMode = sheetMode
        self.content = content
    }
    
    var body: some View {
        content()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(45)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
            .shadow(radius: 25)
            .offset(y: calculateOffset())
            .animation(.spring())
            .edgesIgnoringSafeArea(.all)
    }
    
    private func calculateOffset() -> CGFloat {
        switch sheetMode.wrappedValue {
        case .none:
            return UIScreen.main.bounds.height
        case .third:
            return UIScreen.main.bounds.height * 3/4
        }
    }
}

class AddLicenseViewModel: ObservableObject {
    @Published var showScanner = false
    @Published var deniedCameraAccess = false
    
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
}

struct AddLicenseView: View {
    
    let onFinished: () -> Void
    let onBack: () -> Void

    @State private var sheetMode = SheetMode.none
    @StateObject private var viewModel = AddLicenseViewModel()
    
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

                    Text("Before you can start \nriding")
                        .font(.primary(type: .heading1))
                        .foregroundColor(Color("PrimaryBlue"))
                        .alignLeadingWithHorizontalPadding()
                    
                    Text("Please take a photo or upload the front side of your driving license so we can make sure that it is valid.")
                        .font(.primary(type: .body2))
                        .foregroundColor(Color("PrimaryBlue"))
                        .alignLeadingWithHorizontalPadding()
                        .padding(.top, 10)
                    FormButton(title: "Add driving license", isEnabled: true, action: {
                        sheetMode = .third
                    })
                    .padding(.top, 31)
                }
            }
            FlexibleSheet(sheetMode: $sheetMode) {
                VStack {
                    Button("Upload from gallery", action: {
                        sheetMode = .none
                    })
                    .frame(maxWidth: .infinity)
                    .lightActiveButton()
                    .padding(.horizontal, 24)
                    
                    Button("Take picture now", action: {
                        sheetMode = .none
                        viewModel.scanLicense()
                    })
                    .frame(maxWidth: .infinity)
                    .largeActiveButton()
                    .padding(.horizontal, 24)
                }
            }
            .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                .onEnded{ value in
                    if (-100...100).contains(value.translation.width) &&
                        (0...).contains(value.translation.height) {
                        sheetMode = .none
                    }
                })
        }
        .sheet(isPresented: $viewModel.showScanner) {
            ScannerView { result in
                switch result {
                case .success(let scannedImage):
                    print(scannedImage)
                    // api call to upload image
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } didCancelScanning: {
                viewModel.showScanner = false
            }
        }
    }
}

struct AddLicenseView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                AddLicenseView(onFinished: {}, onBack: {})
                    .previewDevice(device)
            }
        }
    }
}
