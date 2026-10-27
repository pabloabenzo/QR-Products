import Foundation
import Observation

enum CountriesAction {
    case loadProducts
    case loadProductsPlatzi
    case productSelected
    case scanCode(String)
}

@MainActor
@Observable
final class CountriesPresenter {
    var model = CountriesModel()
    private let service = ProductsService()
    
    func action(_ action: CountriesAction) async {
        switch action {
        case .loadProducts:
            do {
                let url = URL(string: "https://fakestoreapi.com/products")!
                let dtos = try await service.fetchProducts(from: url)
                model.products = dtos.map { dto in
                    ProductModel(
                        id: dto.id,
                        title: dto.title,
                        price: dto.price,
                        description: dto.description,
                        category: dto.category,
                        image: dto.image,
                        ratingRate: dto.rating.rate,
                        ratingCount: dto.rating.count
                    )
                }
            } catch {
            }
        case .loadProductsPlatzi:
            do {
                let url = URL(string: "https://api.escuelajs.co/api/v1/products")!
                let dtos = try await service.fetchProductsPlatzi(from: url)
                model.productsPlatzi = dtos.map { dto in
                    ProductModelPlatzi(
                        id: dto.id,
                        title: dto.title,
                        slug: dto.slug,
                        price: dto.price,
                        description: dto.description,
                        categoryName: dto.category.name,
                        categoryImage: dto.category.image,
                        image: dto.images.first ?? "",
                        creationAt: dto.creationAt,
                        updatedAt: dto.updatedAt
                    )
                }
            } catch {
            }
        case .productSelected:
            model.showModal = true
        case .scanCode(let code):
            model.scannedCode = code
            if let codeInt = Int(code.trimmingCharacters(in: .whitespacesAndNewlines)) {
                if (1...15).contains(codeInt) {
                    model.shouldNavigateToCard = true
                } else if codeInt >= 16 {
                    model.showAlert = true
                }
            }
            model.scannedCode = ""
        }
    }
}
