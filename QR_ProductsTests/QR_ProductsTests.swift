import Testing
import Foundation
@testable import QR_Products

struct ProductsTests {
    
    let mockNetworkingService = MockNetworkingService()
    
    @Test func testFetchProductsTestData() async throws {
        let apiClient = ProductsAPIClient(networkingService: mockNetworkingService)
        
        await confirmation("Fetch products data") { confirm in
            apiClient.fetchProductsData { result in
                switch result {
                case .success(let products):
                    #expect(!products.isEmpty, "The result should not be empty.")
                    if let firstProduct = products.first {
                        #expect(firstProduct.id == 1)
                        #expect(firstProduct.title == "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops")
                    } else {
                        Issue.record("The array is empty.")
                    }
                    confirm()
                case .failure(let error):
                    Issue.record("Error: \(error.localizedDescription)")
                    confirm()
                }
            }
        }
    }
    
    class MockNetworkingService: NetworkingService {
        func fetchData(url: URL, completion: @escaping (Data?, Error?) -> Void) {
            let jsonString = """
               [
                {
                    "id": 1,
                    "title": "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
                    "price": 109.95,
                    "description": "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
                    "category": "men's clothing",
                    "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
                    "rating": {
                        "rate": 3.9,
                        "count": 120
                    }
                }
               ]
            """
            if let data = jsonString.data(using: .utf8) {
                completion(data, nil)
            } else {
                let error = NSError(domain: "MockNetworkingServiceErrorDomain", code: -1, userInfo: nil)
                completion(nil, error)
            }
        }
    }
    
    class ProductsAPIClient {
        private let networkingService: NetworkingService
        
        init(networkingService: NetworkingService) {
            self.networkingService = networkingService
        }
        
        func fetchProductsData(completion: @escaping (Result<[ProductData], Error>) -> Void) {
            guard let url = URL(string: "https://fakestoreapi.com/products") else { return }
            networkingService.fetchData(url: url) { data, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let news = try decoder.decode([ProductData].self, from: data!)
                    completion(.success(news))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}

protocol NetworkingService {
    func fetchData(url: URL, completion: @escaping (Data?, Error?) -> Void)
}
