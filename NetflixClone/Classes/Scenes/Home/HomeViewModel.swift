//
//  HomeViewModel.swift
//  NetflixClone
//
//  Created by Joseph Ching on 2022-10-08.
//

import Foundation
import Combine

class HomeViewModel {
    
    // MARK: - Properties
    private let remote = DiscoverMoviesRemote()
    private var hasMoreMovies = true
    
    var cancellables: Set<AnyCancellable> = []
        
    @Published var result: NewMovies? = NewMovies(newMovies: [], section: .featured)
    
    struct NewMovies {
        var newMovies: [Movie]
        var section: Section
    }

    enum Section: String, CaseIterable {
        case featured = "Featured"
        case discover = "Discover"
        case trending = "Trending"
        case top = "Top of All Time"
    }
    
    // MARK: - User Intent(s)
    
    func fetchNewPages(for section: Section, at page: Int) {
        Task {
            do {
                var movies: [Movie]
                switch section {
                case .featured:
                    movies = try await remote.featuredMovies(at: page, type: .movie, time: .day)
                case .discover:
                    movies = try await remote.discoverMovies(at: page)
                case .trending:
                    movies = try await remote.trendingMovies(at: page, type: .tv, time: .day)
                case .top:
                    movies = try await remote.topMovies(at: page)
                }
                self.hasMoreMovies = movies.count > 0
                guard hasMoreMovies else { return }
                result = NewMovies(newMovies: movies, section: section)
            } catch {
                print("❌ Error: \(error)")
            }
        }
    }
    
}
