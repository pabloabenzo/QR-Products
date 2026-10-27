import Foundation
import SwiftUI

struct PaisBView: View {
    
    @State var presenter: CountriesPresenter
    @State private var productsUI = ProductsUI()
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedProductModel: ProductModelPlatzi? = nil
    @State private var showModal = false
    @State private var scannedCode = ""
    @State private var navigateTo = false
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(presenter.model.productsPlatzi, id: \.id) { product in
                        Button {
                            showModal = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                selectedProductModel = product
                                showModal = true
                            }
                        } label: {
                            HStack(alignment: .top, spacing: 12) {
                                VStack(alignment: .leading, spacing: 8) {
                                    AsyncImage(url: URL(string: product.image)) { phase in
                                        switch phase {
                                        case .empty, .failure:
                                            EmptyView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 80, height: 80)
                                                .clipped()
                                                .cornerRadius(8)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                    
                                    Text("$ \(String(format: "%.2f", product.price))")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(productsUI.colorManager(color: "secondary"))
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(product.title)
                                        .font(.headline)
                                        .foregroundStyle(productsUI.colorManager(color: "primary"))
                                    
                                    Text(product.description)
                                        .font(.subheadline)
                                        .lineLimit(3)
                                        .foregroundStyle(productsUI.colorManager(color: "base_gray"))
                                    
                                    Text(product.categoryName)
                                        .font(.headline)
                                }
                            }
                            Spacer()
                        }
                        .padding()
                    }
                    
                    Spacer()
                }
                .sheet(isPresented: $showModal) {
                    ModalView(
                        title: selectedProductModel?.title ?? "",
                        description: selectedProductModel?.description ?? "There is no description available for this product.",
                        scannedCode: $scannedCode
                    )
                }
                .navigationTitle("B Country")
                .navigationBarTitleDisplayMode(.large)
            }
            
            NavigationLink(destination: CardView(presenter: CardPresenter()), isActive: $navigateTo) {
                EmptyView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(productsUI.colorManager(color: "system_blue"))
                    Text("Back")
                        .foregroundStyle(productsUI.colorManager(color: "system_blue"))
                }
            }
        }
        .onAppear {
            navigateTo = false
            Task {
                await presenter.action(.loadProductsPlatzi)
            }
        }
        .onChange(of: scannedCode) { _, newValue in
            let cleanCode = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
            Task {
                await presenter.action(.scanCode(cleanCode))
            }

            if let codeInt = Int(cleanCode) {
                switch codeInt {
                case 1...15:
                    navigateTo = true
                case 16...:
                    showAlert = true
                default:
                    break
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                scannedCode = ""
            }
        }
        .alert("Invalid code", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("The scanned QR code does not belong to any product.")
        }
    }
}
