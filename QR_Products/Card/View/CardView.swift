import SwiftUI

struct CardView: View {
    
    @State var presenter: CardPresenter
    @State private var productsUI = ProductsUI()
    
    @State private var isProgressView = false
    @Environment(\.dismiss) private var dismiss
    
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
                        
                        TextField("Número de tarjeta", text: $presenter.model.cardNumber)
                            .keyboardType(.numberPad)
                        
                        TextField("Expiración (MM/YY)", text: $presenter.model.expiration)
                            .keyboardType(.numbersAndPunctuation)
                        
                        TextField("CVV", text: $presenter.model.cvv)
                            .keyboardType(.numberPad)
                            .frame(width: 80)
                        
                    }
                    
                    Button("Pagar") {
                        isProgressView = true
                        Task {
                            await presenter.action(.pay)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                isProgressView = false
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(productsUI.colorManager(color: "primary"))
                    .cornerRadius(6)
                    .listRowBackground(Color.clear)
                    
                }
                .scrollContentBackground(.hidden)
                
                if isProgressView {
                    ZStack {
                        Color.gray.opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                        ProgressView("")
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                }
            }
            .navigationTitle("Payment")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(productsUI.colorManager(color: "system_blue"))
                    Text("Back")
                        .foregroundColor(productsUI.colorManager(color: "system_blue"))
                }
            }
        }
        .alert("Error", isPresented: $presenter.model.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Incorrect card details.")
        }
        .alert("Success", isPresented: $presenter.model.paymentSuccess) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Payment successful.")
        }
    }
}
