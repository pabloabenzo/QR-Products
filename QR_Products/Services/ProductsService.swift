import Foundation

struct ProductsService {
    func fetchProducts(from url: URL) async throws -> [ProductData] {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([ProductData].self, from: data)
    }
    
    func fetchProductsPlatzi(from url: URL) async throws -> [ProductDataPlatzi] {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([ProductDataPlatzi].self, from: data)
    }
}
