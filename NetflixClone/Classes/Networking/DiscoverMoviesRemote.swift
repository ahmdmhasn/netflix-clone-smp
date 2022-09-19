//
//  DiscoverMoviesRemote.swift
//  NetflixClone
//
//  Created by Ahmed M. Hassan on 14/09/2022.
//

import Foundation

class DiscoverMoviesRemote {
    typealias config = NetworkConfiguration
    
    let networking: NetworkingManager = .shared
    func discoverMovies(at page: Int) async throws -> [Movie] {
        let url = URL(string:"\(config.baseURL)3/discover/movie?api_key=\(config.apiKey)&page=\(page)")!
        
        let urlRequest = URLRequest(url: url)
        let responseModel = try await networking.responseData(urlRequest) as PaginatedMovie
        return responseModel.results
    }
}
