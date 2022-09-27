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
