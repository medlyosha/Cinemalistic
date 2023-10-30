//
//  Persistence.swift
//  Cinemalistic
//
//  Created by Lesha Mednikov on 14.08.2023.
//

import CoreData
struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        for _ in 0..<5 {
            let newItem = MovieEntity(context: viewContext)
            newItem.title = "Example Movie"
            newItem.rating = 7.7
            newItem.releaseDate = "2023-01-01"
            newItem.posterPath = ""
            newItem.tagline = ""
            newItem.budget = 1
            newItem.id = Int32.random(in: 0..<1000)
        }
        do {
            try viewContext.save()
        } catch {
            fatalError("Unresolved error \(error)")
        }
        return controller
    }()
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Cinemalistic")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    func saveMovie(movie: MovieCard) {
           let movieEntity = MovieEntity(context: container.viewContext)
           movieEntity.id = Int32(movie.id)
           movieEntity.title = movie.title
           movieEntity.rating = Double(movie.rating)
           movieEntity.overview = movie.overview
           movieEntity.posterPath = movie.posterPath
           movieEntity.budget = Int32(movie.budget)
           movieEntity.runtime = Int32(movie.runtime)
           movieEntity.releaseDate = movie.releaseDate
           movieEntity.tagline = movie.tagline
           movieEntity.backdropPath = movie.backdropPath
           movieEntity.homePage = movie.homePage
           if let genres = movie.genres {
                for genre in genres {
                    let genreEntity = GenreEntity(context: container.viewContext)
                    genreEntity.id = Int32(genre.id)
                    genreEntity.name = genre.name
                    let movieGenreLink = MovieGenreLink(context: container.viewContext)
                    movieGenreLink.movie = movieEntity
                    movieGenreLink.genre = genreEntity
                }
            }
           do {
               try container.viewContext.save()
           } catch {
               print("Ошибка при сохранении фильма: \(error)")
           }
       }
    func deleteMovie(id: Int) {
            let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            do {
                let movies = try container.viewContext.fetch(fetchRequest)
                for movie in movies {
                    container.viewContext.delete(movie)
                }
                try container.viewContext.save()
            } catch {
                print("Ошибка при удалении фильма: \(error)")
            }
        }
    func isMovieSaved(movie: MovieCard) -> Bool {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)
        do {
            let matchingMovies = try container.viewContext.fetch(fetchRequest)
            return !matchingMovies.isEmpty
        } catch {
            print("Ошибка при проверке сохранения фильма: \(error)")
            return false
        }
    }
}
