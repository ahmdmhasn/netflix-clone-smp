//
//  PaginatedMovie.swift
//  NetflixClone
//
//  Created by Ahmed M. Hassan on 14/09/2022.
//

import Foundation

// MARK: - PaginatedMovie
struct PaginatedMovie: Codable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
