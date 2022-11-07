//
//  FavoriteMoviesStorage.swift
//  NetflixClone
//
//  Created by Ahmed M. Hassan on 07/11/2022.
//

import Foundation
import CoreData

protocol FavoriteMoviesService {
    func addMovieToFavorite(_ movie: Movie)
    func deleteMovieFromFavorite(_ movie: Movie)
    func fetchFavoriteMovies() -> [Movie]
}

class FavoriteMoviesStorage: FavoriteMoviesService {
    let manager = CoreDataManager.shared
    
    var viewContext: NSManagedObjectContext {
        manager.viewContext
    }
    
    func saveALotOfMoviesOnBackground(_ list: [Movie], completion: @escaping () -> Void) {
        manager.performBackgroundTask { backgroundContext in
            // Fill Movies
            // Insert & Save Context
            self.manager.saveContext(context: backgroundContext)
            
            // Background Thread
            DispatchQueue.main.async {
                // Main Thread
                completion()
            }
        }
    }

    func addMovieToFavorite(_ movie: Movie) {
        // 1. Fill movie with data
        let movieEntity = FavoriteMovie(context: viewContext)
        movieEntity.update(with: movie)

        // Insert movie to context
        viewContext.insert(movieEntity)

        // Save context
        manager.saveContext(context: viewContext)
    }

    func deleteMovieFromFavorite(_ movie: Movie) {
        // 1. Fetch movie
        let request = FavoriteMovie.fetchRequest()
        request.fetchLimit = 1
        // select * from FavoriteMovie where movieID == {movie.id}
        request.predicate = NSPredicate(format: "movieID == %d", movie.id)

        do {
            let movies = try viewContext.fetch(request)
            guard let movie = movies.first else {
                return
            }

            // 2. Delete the movie
            manager.viewContext.delete(movie)

            // 3. Save Context
            manager.saveContext(context: viewContext)
        } catch {
            print("Error deleting movie: \(error)")
        }
    }

    func fetchFavoriteMovies() -> [Movie] {
        let request = FavoriteMovie.fetchRequest()
        do {
            let result = try viewContext.fetch(request)
            return result.map { $0.toMovie() }
        } catch {
            print("Error fetching movies: \(error)")
            return []
        }
    }
}
