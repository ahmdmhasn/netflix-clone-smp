//
//  NetworkingManager.swift
//  NetflixClone
//
//  Created by Ahmed M. Hassan on 14/09/2022.
//

import Foundation

class NetworkingManager {
    static let shared = NetworkingManager()
    private let session = URLSession.shared
    
    private init() { }
    
    func responseData<T: Decodable>(_ request: URLRequest) async throws -> T{
        return try await withCheckedThrowingContinuation { continuation in
            self.session.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    continuation.resume(throwing: error ?? NSError())
                    return
                }
                
                // Try to parse the data
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    continuation.resume(returning: decoded)
                } catch {
                    continuation.resume(throwing: error)
                }
            }.resume()
        }
    }
}

// MARK: - Movie
struct Movie: Codable {
    let id: Int
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
