//
//  MovieInfoViewModel.swift
//  NetflixClone
//
//  Created by Joseph Ching on 2022-10-09.
//

import Foundation

class MovieInfoViewModel {
    var id: Int
    var title: String?
    var posterPath: String?
    var description: String?
    var rating: Double?
    var date: String?
    var posterURL: URL? {
        get {
            guard let posterPath = posterPath else { return nil }
            if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)"){
                return imageUrl
            } else {
                return nil
            }
        }
    }
    
    init(id: Int, title: String?, posterPath: String?, description: String?, rating: Double?, date: String? ) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.description = description
        self.rating = rating
        self.date = date
    }
}


// MARK: - User intent(s)

extension MovieInfoViewModel {
    func addToFavourites(id: Int) {
        //logic for adding to fav list
    }
}
