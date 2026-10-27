import Foundation
import Observation

@Observable
final class APIViewModel {
    var url = URL(string: "https://fakestoreapi.com/products")
    var urlPlatzi = URL(string: "https://api.escuelajs.co/api/v1/products")
    
    func fetchData<T: Decodable>(from url: URL) async throws -> [T] {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([T].self, from: data)
    }
}
