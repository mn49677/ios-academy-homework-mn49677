//
//  Review.swift
//  TV Shows
//
//  Created by mn on 27.07.2022..
//

import Foundation

// MARK: - Welcome
struct ReviewResponse: Codable {
    let reviews: [Review]
    let meta: Meta
}

// MARK: - Meta
struct ReviewMeta: Codable {
    let pagination: ReviewPagination
}

// MARK: - Pagination
struct ReviewPagination: Codable {
    let count, page, items, pages: Int
}

// MARK: - Review
struct Review: Codable {
    let id: String
    let comment: String?
    let rating, showID: Int
    let user: ReviewUser

    enum CodingKeys: String, CodingKey {
        case id, comment, rating
        case showID = "show_id"
        case user
    }
}

// MARK: - User
struct ReviewUser: Codable {
    let id, email: String
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, email
        case imageURL = "image_url"
    }
}
