//
//  MovieStore.swift
//  NetflixClone
//
//  Created by Joseph Ching on 2022-11-14.
//

import Foundation

class MovieStore {
    var store = [Int:Movie]()
    
    func fetchMovieById(id: Int) -> Movie? {
        return store[id]
    }
    
    func addMovie(movie: Movie) {
        store[movie.id] = movie
    }
    
    func addMovies(movies: [Movie]) {
        for movie in movies {
            addMovie(movie: movie)
        }
    }
}
