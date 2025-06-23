//
//  QRProductsViewModel.swift
//  QR_Products
//
//  Created by Pablo Benzo on 12/06/2025.
//

import Foundation
import Observation
import Combine

@Observable
final class QRProductsViewModel: ObservableObject {
    
    var url = URL(string: "https://fakestoreapi.com/products")
    var urlPlatzi = URL(string: "https://api.escuelajs.co/api/v1/products")
    
    func fetchData<T: Decodable>(from url: URL) async throws -> [T] {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([T].self, from: data)
    }
    
}
