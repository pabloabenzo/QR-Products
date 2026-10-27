import SwiftUI

struct HomeView: View {
    
    @State var presenter: HomePresenter
    @State private var productsUI = ProductsUI()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .foregroundStyle(productsUI.colorManager(color: "secondary"))
                    .ignoresSafeArea(.all)
                    .onTapGesture {
                        productsUI.hideKeyboard()
                    }
                
                VStack {
                    VStack {
                        Text("Please select the country of residence:")
                            .font(.custom("Montserrat", size: 18))
                            .foregroundStyle(productsUI.colorManager(color: "base_black"))
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.leading, 10).padding(.bottom, 100)
                    
                    Button(action: {
                        Task {
                            await presenter.action(.navigateToA)
                        }
                    }) {
                        Text("A Country")
                            .font(.custom("Montserrat", size: 16))
                            .foregroundStyle(productsUI.colorManager(color: "base_white"))
                            .multilineTextAlignment(.leading)
                    }
                    .frame(width: productsUI.deviceWidth / 2, height: 50)
                    .background(productsUI.colorManager(color: "primary"))
                    .cornerRadius(6)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    .padding(.bottom, 20)
                    
                    Button(action: {
                        Task {
                            await presenter.action(.navigateToB)
                        }
                    }) {
                        Text("B Country")
                            .font(.custom("Montserrat", size: 16))
                            .foregroundStyle(productsUI.colorManager(color: "base_white"))
                            .multilineTextAlignment(.leading)
                    }
                    .frame(width: productsUI.deviceWidth / 2, height: 50)
                    .background(productsUI.colorManager(color: "primary"))
                    .cornerRadius(6)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    .padding(.bottom, 20)
                }
                .padding()
                
                if presenter.model.isLoadingToA {
                    ZStack {
                        Color.gray.opacity(0.3)
                            .ignoresSafeArea(.all)
                        ProgressView("")
                            .progressViewStyle(CircularProgressViewStyle())
                        
                        NavigationLink(
                            destination: PaisAView(presenter: CountriesPresenter()),
                            isActive: $presenter.model.isNavigatingToA
                        ) { }
                    }
                } else if presenter.model.isLoadingToB {
                    ZStack {
                        Color.gray.opacity(0.3)
                            .ignoresSafeArea(.all)
                        ProgressView("")
                            .progressViewStyle(CircularProgressViewStyle())
                        
                        NavigationLink(
                            destination: PaisBView(presenter: CountriesPresenter()),
                            isActive: $presenter.model.isNavigatingToB
                        ) { }
                    }
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationBarBackButtonHidden(true)
    }
}
