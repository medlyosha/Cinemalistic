//
//  MovieDetailsResult.swift
//  Cinemalistic
//
//  Created by Lesha Mednikov on 22.09.2023.
//

import Foundation
import Combine
import UIKit
import _AVKit_SwiftUI
class MovieDetailsResult: ObservableObject {
    @Published var movieCard = MovieCard(id: 0, title: "", overview: "", posterPath: "", releaseDate: "", backdropPath: "", budget: 1, runtime: 0, genres: [], homePage: "", rating: 0.0, tagline: "")
    @Published var isSaved: Bool = false
    @Published var trailers: [Trailer] = []
    @Published var reviews: [Review] = []
    @Published var credits: [Cast] = []
    @Published var networkError: Error? = nil
    private var trailersCancellable: Set<AnyCancellable> = []
    private var movieCancellable: Set<AnyCancellable> = []
    private var reviewCancellable: Set<AnyCancellable> = []
    private var creditsCancellable: Set<AnyCancellable> = []
    var currentPage = 1
    private var totalPages = 1
    private var isLoading = false
    func getMovieDetails(for movieID: Int) {
        guard let url = APIConstants.movieDetailsURL(movieID: movieID) else {
            return
        }
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: MovieCard.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    self?.networkError = error
                }
            }, receiveValue: { [weak self] movieCard in
                self?.networkError = nil
                self?.movieCard = movieCard
                self?.isSaved = PersistenceController.shared.isMovieSaved(movie: movieCard)
            })
            .store(in: &movieCancellable)
        getTrailers(for: movieID)
        getReviews(for: movieID)
        getCredits(for: movieID)
    }
    func getTrailers(for movieID: Int) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=fb039c8400b199b5bec859c331ba5434"
        let url = URL(string: urlString)
        URLSession.shared.dataTaskPublisher(for: url!)
            .map { $0.data }
            .decode(type: TrailerApiResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                                switch completion {
                                case .finished:
                                    break
                                case .failure(let error):
                                    print("Error fetching trailers: \(error)")
                                }
                            }, receiveValue: { [weak self] trailers in
                                self?.trailers.append(trailers.results.filter { $0.name.range(of: "Trailer", options: .caseInsensitive) != nil }.first ?? Trailer(id: "", name: "", key: "", site: "", type: "", official: false, publishedAt: "") )
                            })
                            .store(in: &trailersCancellable)
    }
    func getReviews(for movieID: Int) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)/reviews?api_key=fb039c8400b199b5bec859c331ba5434"
        let url = URL(string: urlString)
        guard currentPage <= totalPages && !isLoading else {
               return
           }
           isLoading = true
        URLSession.shared.dataTaskPublisher(for: url!)
            .map { $0.data }
            .decode(type: ReviewApiResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                                switch completion {
                                case .finished:
                                    self?.isLoading = false
                                case .failure(let error):
                                    print("Error fetching trailers: \(error)")
                                }
                            }, receiveValue: { [weak self] reviews in
                                self?.totalPages = reviews.total_pages
                                self?.currentPage += 1
                                self?.reviews.append(contentsOf: reviews.results)
                            })
                            .store(in: &reviewCancellable)
    }
    func getCredits(for movieID: Int) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)/credits?api_key=fb039c8400b199b5bec859c331ba5434"
        let url = URL(string: urlString)
        URLSession.shared.dataTaskPublisher(for: url!)
            .map { $0.data }
            .decode(type: CastApiResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                                switch completion {
                                case .finished:
                                    break
                                case .failure(let error):
                                    print("Error fetching trailers: \(error)")
                                }
                            }, receiveValue: { [weak self] credits in
                                self?.credits.append(contentsOf: credits.cast.filter {$0.knownForDepartment == "Acting"})
                                print(credits.cast)
                            })
                            .store(in: &creditsCancellable)
    }
}
