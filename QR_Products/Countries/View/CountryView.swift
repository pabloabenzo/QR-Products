//
//  CountryView.swift
//  QR_Products
//
//  Created by Pablo Benzo on 12/06/2025.
//

import SwiftUI

struct CountryView: View {
    
    var viewModel = QRProductsViewModel()
    var productsUI = ProductsUI()
    @Environment(\.dismiss) private var dismiss

    @State private var progress = 0.6
    @State var showView = false
    
    @State var usuario: String = ""
    @State var password: String = ""
    
    // ProgressView
    @State private var isNavigatingToA = false
    @State private var isLoadingToA = false
    @State private var isNavigatingToB = false
    @State private var isLoadingToB = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .foregroundColor(productsUI.colorManager(color: "secondary"))
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        productsUI.hideKeyboard()
                    }
                
                VStack {
                    
                    VStack {
                        Text("Seleccione el país de residencia:")
                            .font(.custom("Montserrat", size: 18))
                            .tint(productsUI.colorManager(color: "base_black"))
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.leading, -50).padding(.bottom, 100)
                    
                    Button(action: loadAndNavigateToA) {
                        
                            Text("País A")
                                .font(.custom("Montserrat", size: 16))
                                .tint(productsUI.colorManager(color: "base_white"))
                                .multilineTextAlignment(.leading)
                        
                    }
                    .frame(width: productsUI.deviceWidth / 2, height: 50)
                    .background(productsUI.colorManager(color: "primary"))
                    .cornerRadius(6)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    .padding(.bottom, 20)
                    
                    Button(action: loadAndNavigateToB) {
                        
                        Text("País B")
                            .font(.custom("Montserrat", size: 16))
                            .tint(productsUI.colorManager(color: "base_white"))
                            .multilineTextAlignment(.leading)
                        
                    }
                    .frame(width: productsUI.deviceWidth / 2, height: 50)
                    .background(productsUI.colorManager(color: "primary"))
                    .cornerRadius(6)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    .padding(.bottom, 20)
                    
                }
                .padding()
                
                if isLoadingToA {
                    ZStack {
                        Color.gray.opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                        ProgressView("")
                            .progressViewStyle(CircularProgressViewStyle())
                        
                        NavigationLink(
                            destination: PaisAView(),
                            isActive: $isNavigatingToA
                        ) { }
                    }
                } else if isLoadingToB {
                    ZStack {
                        Color.gray.opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                        ProgressView("")
                            .progressViewStyle(CircularProgressViewStyle())
                        
                        NavigationLink(
                            destination: PaisBView(),
                            isActive: $isNavigatingToB
                        ) { }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func loadAndNavigateToA() {
        isLoadingToA = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoadingToA = false
            isNavigatingToA = true
        }
    }
    
    private func loadAndNavigateToB() {
        isLoadingToB = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoadingToB = false
            isNavigatingToB = true
        }
    }

}

#Preview {
    CountryView()
}
