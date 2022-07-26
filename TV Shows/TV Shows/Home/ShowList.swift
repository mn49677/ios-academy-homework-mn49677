//
//  ShowList.swift
//  TV Shows
//
//  Created by mn on 26.07.2022..
//

import Foundation

// MARK: - Shows
struct ShowsResponse: Codable {
    let shows: [Show]
    let meta: Meta
}

// MARK: - Meta
struct Meta: Codable {
    let pagination: Pagination
}

// MARK: - Pagination
struct Pagination: Codable {
    let count, page, items, pages: Int
}

// MARK: - Show
struct Show: Codable {
    let id: String
    let averageRating: Int
    let showDescription: String
    let imageURL: String
    let noOfReviews: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case id
        case averageRating = "average_rating"
        case showDescription = "description"
        case imageURL = "image_url"
        case noOfReviews = "no_of_reviews"
        case title
    }
}
