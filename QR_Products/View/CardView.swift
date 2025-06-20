//
//  CardView.swift
//  QR_Products
//
//  Created by Pablo Benzo on 12/06/2025.
//

import SwiftUI

struct CardView: View {
    
    var productsUI = ProductsUI()
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
                        cardVM.pay()
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
                    Button("OK", role: .cancel) { }
                }
                .alert("Datos inválidos", isPresented: $cardVM.showError) {
                    Button("Intentar de nuevo", role: .cancel) { }
                } message: {
                    Text("Verifica que todos los campos sean correctos.")
                }
                .navigationTitle("Pago")
                .background(
                    NavigationCoordinator(navigateToHome: $cardVM.navigateToHome)
                )
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

// Struct para poder navegar desde SwiftUI a un UIViewController.
struct NavigationCoordinator: UIViewControllerRepresentable {
    @Binding var navigateToHome: Bool

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .clear
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if navigateToHome && !context.coordinator.hasPushed {
            context.coordinator.hasPushed = true
            let productsVC = LoginViewController()
            if let nav = uiViewController.navigationController {
                nav.pushViewController(productsVC, animated: true)
                DispatchQueue.main.async {
                    self.navigateToHome = false
                    context.coordinator.hasPushed = false
                }
            }
        }
    }
    
    // Coordinator para evitar multiples cargas en la home.
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var hasPushed = false
    }
}

#Preview {
    CardView()
}
