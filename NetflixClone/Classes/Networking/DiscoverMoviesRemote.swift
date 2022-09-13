//
//  DiscoverMoviesRemote.swift
//  NetflixClone
//
//  Created by Ahmed M. Hassan on 14/09/2022.
//

import Foundation

class DiscoverMoviesRemote {
    
    let networking: NetworkingManager = .shared
    
    /// https://api.themoviedb.org/3/discover/movie?api_key=6e902ca7ab53142340b3b09e3746bfcc&page=1
    ///
    func discoverMovies(at page: Int) async throws -> [Movie] {
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=6e902ca7ab53142340b3b09e3746bfcc&page=\(page)")!
        let urlRequest = URLRequest(url: url)
        let responseModel = try await networking.responseData(urlRequest) as PaginatedMovie
        return responseModel.results
    }
}
