//
//  QR_ProductsTests.swift
//  qr_productsTests
//
//  Created by Pablo Benzo on 13/06/2025.
//

import XCTest
@testable import QR_Products

protocol NetworkingService {
    func fetchData(url: URL, completion: @escaping (Data?, Error?) -> Void)
}

final class ProductsTests: XCTestCase {
    
    var apiClient: ProductsAPIClient!
    
    override func setUp() {
        super.setUp()

        let mockNetworkingService = MockNetworkingService()
        apiClient = ProductsAPIClient(networkingService: mockNetworkingService)
    }
    override func tearDown() {
        apiClient = nil
        super.tearDown()
    }
    
    func testFetchProductsTestData() {
        let expectation = self.expectation(description: "Fetch products data")
        apiClient.fetchProductsData { result in
            switch result {
            case .success(let products):
                XCTAssertFalse(products.isEmpty, "The result should not be empty.")
                
                if let firstProduct = products.first {
                    XCTAssertEqual(firstProduct.id, 1)
                    XCTAssertEqual(firstProduct.title, "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops")
                } else {
                    XCTFail("The array is empty.")
                }
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
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
