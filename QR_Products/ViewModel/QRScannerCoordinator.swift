//
//  QRScannerCoordinator.swift
//  QR_Products
//
//  Created by Pablo Benzo on 12/06/2025.
//

import AVFoundation
import UIKit
import SwiftUI

class QRScannerCoordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    var parent: QRScannerView

    init(parent: QRScannerView) {
        self.parent = parent
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {

        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           metadataObject.type == .qr,
           let stringValue = metadataObject.stringValue {
            parent.foundCode(stringValue)
        }
    }
}

struct QRScannerView: UIViewRepresentable {
    var foundCode: (String) -> Void

    func makeCoordinator() -> QRScannerCoordinator {
        return QRScannerCoordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let session = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              session.canAddInput(videoInput) else {
            return view
        }

        session.addInput(videoInput)

        let metadataOutput = AVCaptureMetadataOutput()
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: .main)
            metadataOutput.metadataObjectTypes = [.qr]
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = UIScreen.main.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        session.startRunning()
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
