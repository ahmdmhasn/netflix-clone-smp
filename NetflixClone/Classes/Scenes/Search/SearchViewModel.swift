//
//  SearchViewModel.swift
//  NetflixClone
//
//  Created by Joseph Ching on 2022-10-09.
//

import Foundation
import Combine
class SearchViewModel {
    // MARK: Properties
    private let remote = DiscoverMoviesRemote()
    private var hasMoreMovies = true
    var cancellables: Set<AnyCancellable> = []
        
    @Published var result: NewMovies? = NewMovies(newMovies: [], section: .mainResults)
    
    enum Section: String, CaseIterable {
        case mainResults = "Main Results"
    }

}

// MARK: - User intent(s)
extension SearchViewModel {
    struct NewMovies {
        var newMovies: [MovieSearchMulti]
        var section: Section
    }

    func fetchNewPages(for section: Section, at page: Int, with query: [String]) {
        guard query.count > 0 else { return }
        Task {
            do {
                var movies: [MovieSearchMulti]
                switch section {
                case .mainResults:
                    movies = try await remote.searchMulti(query: query, at: page)
                }
                self.hasMoreMovies = movies.count > 0
                if(!hasMoreMovies) {
                    print("No result for search: \(query.joined(separator: " "))")
                }
                guard hasMoreMovies else { return }
                result = NewMovies(newMovies: movies, section: section)
            } catch {
                print("❌ Error: \(error)")
            }
        }
    }
}
