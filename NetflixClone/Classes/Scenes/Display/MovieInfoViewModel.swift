//
//  MovieInfoViewModel.swift
//  NetflixClone
//
//  Created by Joseph Ching on 2022-10-09.
//

import Foundation
import struct SwiftUI.Color

class MovieInfoViewModel {
    private let movie: Movie
    
    var title: String? {
        movie.title
    }
    var description: String? {
        movie.overview
    }
    var date: String? {
        movie.releaseDate
    }
    var rating: Double? {
        movie.voteAverage
    }
    var ratingColor: Color {
        ratingColor(rating: rating ?? 0)
    }
    
    
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
    func addToFavourites() {
        //logic for adding to fav list
    }
    
    func ratingColor(rating: Double) -> Color {
        switch rating {
        case 0..<3:
            return .red
        case 3..<5:
            return .orange
        case 5..<7:
            return .yellow
        default:
            return .green
        }
    }
}
