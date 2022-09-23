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
    func discoverMovies(at page: Int ) async throws -> [Movie] {
        let url = URL(string:"\(config.baseURL)discover/movie?api_key=\(config.apiKey)&page=\(page)")!
        
        let urlRequest = URLRequest(url: url)
        let responseModel = try await networking.responseData(urlRequest) as PaginatedMovie
        return responseModel.results
    }
    
    
    enum mediaType: String {
        case all = "all"
        case movie = "movie"
        case tv = "tv"
        case person = "person"
    }
    enum timeWindow: String {
        case day = "day"
        case week = "week"
    }
    func trendingMovies(at page: Int, type: mediaType, time: timeWindow ) async throws -> [Movie] {
        let url = URL(string: "\(config.baseURL)trending/\(type.rawValue)/\(time.rawValue)?api_key=\(config.apiKey)&page=\(page)")!
        let urlRequest = URLRequest(url: url)
        print(url.description)
        let responseModel = try await networking.responseData(urlRequest) as PaginatedMovie
        return responseModel.results
    }
    
    func featuredMovies(at page: Int, type: mediaType, time: timeWindow ) async throws -> [Movie] {
        let url = URL(string: "\(config.baseURL)trending/\(type.rawValue)/\(time.rawValue)?api_key=\(config.apiKey)&page=\(page)")!
        let urlRequest = URLRequest(url: url)
        print(url.description)
        let responseModel = try await networking.responseData(urlRequest) as PaginatedMovie
        return responseModel.results
    }
    
    func topMovies(at page: Int) async throws -> [Movie] {
        let url = URL(string:"\(config.baseURL)discover/movie?api_key=\(config.apiKey)&page=\(page)&sort_by=vote_count.desc")!
        let urlRequest = URLRequest(url: url)
        let responseModel = try await networking.responseData(urlRequest) as PaginatedMovie
        return responseModel.results
    }
}
