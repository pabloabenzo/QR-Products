//
//  ModalView.swift
//  QR_Products
//
//  Created by Pablo Benzo on 12/06/2025.
//

import SwiftUI

struct ModalView: View {
    
    var productsUI = ProductsUI()
    
    let title: String
    let description: String
    
    @State private var isScannerVisible = false
    @Binding var scannedCode: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {

            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
            
            Text("Escanea el código QR para proceder a la compra")
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .multilineTextAlignment(.center)
            
            Button {
                isScannerVisible = true
            } label: {
                Text("Abrir QR")
            }
            .frame(width: productsUI.deviceWidth / 2, height: 50)
            .background(productsUI.colorManager(color: "primary"))
            .cornerRadius(6)
            .shadow(color: .gray, radius: 2, x: 0, y: 2)
            .padding(.bottom, 20)

            if isScannerVisible {
                QRScannerView { code in
                    scannedCode = code
                    dismiss()
                }
                .frame(height: 300)
                .cornerRadius(12)
            }
            
            Spacer()
        }
        .padding()
    }
    
}


