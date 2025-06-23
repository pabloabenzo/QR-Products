//
//  Model.swift
//  QR_Products
//
//  Created by Pablo Benzo on 12/06/2025.
//

import Foundation

struct ProductData: Decodable, Hashable {
    var id: Int
    var title: String
    var price: Double
    var description: String
    var category: String
    var image: String
    var rating: Rating
    
    struct Rating: Decodable, Hashable {
        var rate: Double
        var count: Int
    }
}

struct ProductDataPlatzi: Decodable, Identifiable {
    let id: Int
    let title: String
    let slug: String
    let price: Double
    let description: String
    let category: Category
    let images: [String]
    let creationAt: String
    let updatedAt: String

    struct Category: Decodable {
        let id: Int
        let name: String
        let slug: String
        let image: String
        let creationAt: String
        let updatedAt: String
    }
}
