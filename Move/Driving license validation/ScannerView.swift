//
//  ScannerView.swift
//  Move
//
//  Created by Daria Andrioaie on 30.08.2022.
//

import SwiftUI
import VisionKit

struct ScannerView: UIViewControllerRepresentable {
    var didFinishScanning: ((_ result: Result<[UIImage], Error>) -> Void)
    var didCancelScanning: () -> Void
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let scannerView: ScannerView
        
        init(with scannerView: ScannerView) {
            self.scannerView = scannerView
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            var scannedImages = [UIImage]()
            
            for index in 0..<scan.pageCount {
                scannedImages.append(scan.imageOfPage(at: index))
            }
            
            scannerView.didFinishScanning(.success(scannedImages))
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            scannerView.didCancelScanning()
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            scannerView.didFinishScanning(.failure(error))
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(with: self)
    }
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scannerViewController = VNDocumentCameraViewController()
        
        scannerViewController.delegate = context.coordinator
        
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
    }
    
}
