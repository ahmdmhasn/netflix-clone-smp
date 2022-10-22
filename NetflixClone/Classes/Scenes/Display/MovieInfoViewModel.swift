//
//  MovieInfoViewModel.swift
//  NetflixClone
//
//  Created by Joseph Ching on 2022-10-09.
//

import Foundation

class MovieInfoViewModel {
    let movie: Movie
    
    var posterURL: URL? {
        get {
            guard let posterPath = movie.posterPath else { return nil }
            return URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")
        }
    }
    
    init(movie: Movie) {
        self.movie = movie
    }
}


// MARK: - User intent(s)

extension MovieInfoViewModel {
    func addToFavourites(id: Int) {
        //logic for adding to fav list
    }
}
