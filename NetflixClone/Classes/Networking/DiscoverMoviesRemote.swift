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
        case day = "day"
        case week = "week"
    }
    func trendingMovies(at page: Int, type: MediaType, time: TimeWindow ) async throws -> [Movie] {
        let url = URL(string: "\(Config.baseURL)trending/\(type.rawValue)/\(time.rawValue)?api_key=\(Config.apiKey)&page=\(page)")!
        let urlRequest = URLRequest(url: url)
        print(url.description)
        let responseModel = try await networking.responseData(urlRequest) as PaginatedList<Movie>
        return responseModel.results
    }
    
    func featuredMovies(at page: Int, type: MediaType, time: TimeWindow ) async throws -> [Movie] {
        let url = URL(string: "\(Config.baseURL)trending/\(type.rawValue)/\(time.rawValue)?api_key=\(Config.apiKey)&page=\(page)")!
        let urlRequest = URLRequest(url: url)
        print(url.description)
        let responseModel = try await networking.responseData(urlRequest) as PaginatedList<Movie>
        return responseModel.results
    }
    
    func topMovies(at page: Int) async throws -> [Movie] {
        let url = URL(string:"\(Config.baseURL)discover/movie?api_key=\(Config.apiKey)&page=\(page)&sort_by=vote_count.desc")!
        let urlRequest = URLRequest(url: url)
        let responseModel = try await networking.responseData(urlRequest) as PaginatedList<Movie>
        return responseModel.results
    }
    
}
