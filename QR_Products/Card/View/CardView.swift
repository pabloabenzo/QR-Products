//
//  CardView.swift
//  QR_Products
//
//  Created by Pablo Benzo on 12/06/2025.
//

import SwiftUI

struct CardView: View {
    
    var productsUI = ProductsUI()
    @State private var isProgressView = false
    @State private var isNavigatingToHome = false
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var cardVM = CardViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .foregroundColor(productsUI.colorManager(color: "secondary"))
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        productsUI.hideKeyboard()
                    }
                Form {
                    
                    Image("debit_card")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Section(header: Text("Datos de la tarjeta")) {
                        
                        TextField("Número de tarjeta", text: $cardVM.cardNumber)
                            .keyboardType(.numberPad)
                        
                        TextField("CVV", text: $cardVM.cvv)
                            .keyboardType(.numberPad)
                            .frame(width: 80)
                        
                        TextField("Expiración (MM/YY)", text: $cardVM.expiration)
                            .keyboardType(.numbersAndPunctuation)
                    }
                    
                    Button("Pagar") {
                        isProgressView = true
                        cardVM.pay()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isProgressView = false
                            if cardVM.isPaymentValid {
                                cardVM.paymentSuccess = true
                            } else {
                                cardVM.showError = true
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(productsUI.colorManager(color: "primary"))
                    .cornerRadius(8)
                    
                    .alert("Datos inválidos", isPresented: $cardVM.showError) {
                        Button("Intentar de nuevo", role: .cancel) { }
                    } message: {
                        Text("Verifica que todos los campos sean correctos.")
                    }
                    .navigationTitle("Pago")
                }
                .alert("Pago exitoso", isPresented: $cardVM.paymentSuccess) {
                    Button("OK", role: .cancel) {
                        isNavigatingToHome = true
                    }
                }
                .alert("Datos inválidos", isPresented: $cardVM.showError) {
                    Button("Intentar de nuevo", role: .cancel) { }
                } message: {
                    Text("Verifica que todos los campos sean correctos.")
                }
                .navigationTitle("Pago")
                
                if isProgressView {
                    ZStack {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                    }
                }
                
                NavigationLink(
                    destination: HomeView(),
                    isActive: $isNavigatingToHome
                ) { EmptyView() }
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(productsUI.colorManager(color: "system_blue"))
                    Text("Volver")
                        .foregroundColor(productsUI.colorManager(color: "system_blue"))
                }
            }
        }
    }
}

#Preview {
    CardView()
}
