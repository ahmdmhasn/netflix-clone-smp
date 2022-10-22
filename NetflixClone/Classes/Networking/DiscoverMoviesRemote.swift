//
//  DiscoverMoviesRemote.swift
//  NetflixClone
//
//  Created by Ahmed M. Hassan on 14/09/2022.
//

import Foundation

class DiscoverMoviesRemote {
    typealias Config = NetworkConfiguration
    let networking: NetworkingManager = .shared
    // MARK: - Discover movies (/discover/movie)
    // https://developers.themoviedb.org/3/discover/movie-discover
    func discoverMovies(at page: Int ) async throws -> [Movie] {
        let url = URL(string: "\(Config.baseURL)discover/movie?api_key=\(Config.apiKey)&page=\(page)")!
        let urlRequest = URLRequest(url: url)
        let responseModel = try await networking.responseData(urlRequest) as PaginatedList<Movie>
        return responseModel.results
    }
    enum MediaType: String {
        case all
        case movie
        case tv
        case person
    }
    enum TimeWindow: String {
        case day
        case week
    }
    func trendingMovies(at page: Int, type: MediaType, time: TimeWindow ) async throws -> [Movie] {
        let urlString = "\(Config.baseURL)trending/\(type.rawValue)/\(time.rawValue)?api_key=\(Config.apiKey)&page=\(page)"
        let results = try await(getResponse(urlString: urlString)) as [Movie]
        return results
    }
    func featuredMovies(at page: Int, type: MediaType, time: TimeWindow ) async throws -> [Movie] {
        let urlString = "\(Config.baseURL)trending/\(type.rawValue)/\(time.rawValue)?api_key=\(Config.apiKey)&page=\(page)"
        let results = try await(getResponse(urlString: urlString)) as [Movie]
        return results
    }
    // MARK: - Search multi (/search/multi)
    // https://developers.themoviedb.org/3/search/multi-search
    func searchMulti(query: [String], at page: Int) async throws -> [MovieSearchMulti] {
        let queryString = query.joined(separator: "+")

        let urlString = "\(Config.baseURL)search/multi?api_key=\(Config.apiKey)&query=\(queryString)&page=\(page)"
        let results = try await(getResponse(urlString: urlString)) as [MovieSearchMulti]
        return results
    }
}

extension DiscoverMoviesRemote {
    func getResponse<ResultType: Decodable>(urlString: String) async throws -> [ResultType] {
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        let responseModel = try await networking.responseData(urlRequest) as PaginatedList<ResultType>
        return responseModel.results
    }
    
    func topMovies(at page: Int) async throws -> [Movie] {
        let url = URL(string:"\(Config.baseURL)discover/movie?api_key=\(Config.apiKey)&page=\(page)&sort_by=vote_count.desc")!
        let urlRequest = URLRequest(url: url)
        let responseModel = try await networking.responseData(urlRequest) as PaginatedList<Movie>
        return responseModel.results
    }
    
}
