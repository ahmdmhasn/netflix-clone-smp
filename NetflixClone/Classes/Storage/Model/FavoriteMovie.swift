//
//  FavoriteMovie.swift
//  NetflixClone
//
//  Created by Ahmed M. Hassan on 07/11/2022.
//

import Foundation
import CoreData

@objc(FavoriteMovie)
class FavoriteMovie: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovie> {
        return NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
    }
    
    @NSManaged var movieID: Int64
    @NSManaged var title: String
    @NSManaged var releaseDate: String
    @NSManaged var voteCount: Int64
}

// MARK: Helpers
//
extension FavoriteMovie {
    
    func update(with model: Movie) {
        movieID = Int64(model.id)
        title = model.title ?? ""
        releaseDate = model.releaseDate ?? ""
        voteCount = Int64(model.voteCount ?? .zero)
    }
    
    func toMovie() -> Movie {
        return Movie(id: Int(movieID),
                     adult: nil,
                     backdropPath: nil,
                     genreIDS: [],
                     originalLanguage: nil,
                     originalTitle: nil,
                     overview: nil,
                     popularity: nil,
                     posterPath: nil,
                     releaseDate: releaseDate,
                     title: title,
                     video: nil,
                     voteAverage: nil,
                     voteCount: Int(voteCount))
    }
}
