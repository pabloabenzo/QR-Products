//
//  PaisAView.swift
//  QR_Products
//
//  Created by Pablo Benzo on 12/06/2025.
//

import SwiftUI

struct PaisAView: View {
    
    var viewModel = APIViewModel()
    var productsUI = ProductsUI()
    
    @State private var products: [ProductData] = []
    @State private var selectedProduct: ProductData? = nil
    @Environment(\.dismiss) private var dismiss
    
    // Navegación a otras vistas.
    @State private var showModal = false
    @State private var scannedCode = ""
    @State private var navigateTo = false
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(products, id: \.hashValue) { product in
                        Button {
                            showModal = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                selectedProduct = product
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
                                        .foregroundColor(productsUI.colorManager(color: "secondary"))
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(product.title)
                                        .font(.headline)
                                        .foregroundColor(productsUI.colorManager(color: "primary"))
                                    
                                    Text(product.description)
                                        .font(.subheadline)
                                        .lineLimit(3)
                                        .foregroundColor(productsUI.colorManager(color: "base_gray"))
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
                        title: selectedProduct?.title ?? "",
                        description: selectedProduct?.description ?? "No hay descripcion disponible para este producto.",
                        scannedCode: $scannedCode
                    )
                }
                .navigationTitle("Pais A")
                .navigationBarTitleDisplayMode(.large)
            }
            
            NavigationLink(destination: CardView(), isActive: $navigateTo) {
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
                        .foregroundColor(productsUI.colorManager(color: "system_blue"))
                    Text("Volver")
                        .foregroundColor(productsUI.colorManager(color: "system_blue"))
                }
            }
        }
        .onAppear {
            navigateTo = false
            Task {
                do {
                    products = try await viewModel.fetchData(from: viewModel.url!)
                } catch {
                    print("Error al cargar los productos: \(error)")
                }
            }
        }
        .onChange(of: scannedCode) { newValue in
            let cleanCode = newValue.trimmingCharacters(in: .whitespacesAndNewlines)

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
        .alert("Código inválido", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("El código QR escaneado no pertenece a ningun producto.")
        }
    }
}

#Preview {
    PaisAView()
}
