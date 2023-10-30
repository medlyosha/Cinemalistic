//
//  MoviesViewModel.swift
//  Cinemalistic
//
//  Created by Lesha Mednikov on 14.08.2023.
//


import Foundation
import Combine
class MoviesCategoriesResult: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var networkError: Error? = nil
    private var cancellables: Set<AnyCancellable> = []
    var currentPage = 1
    private var totalPages = 1
    private var isLoading = false
    func loadMoviesByCategory(for category: MovieCategory) {
        guard let url = APIConstants.movieListURL(category: category, page: currentPage) else {
            return
        }
        guard currentPage <= totalPages else {
            return
        }
        if isLoading {
            return
        }
        isLoading = true
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: MovieApiResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isLoading = false
                case .failure(let error):
                    print("Error: \(error)")
                    self?.networkError = error
                    self?.isLoading = false
                }
            }, receiveValue: { [weak self] response in
                self?.networkError = nil
                self?.totalPages = response.total_pages
                self?.movies.append(contentsOf: response.results)
                self?.currentPage += 1
            })
            .store(in: &cancellables)
    }
    
    func loadNextPageIfNeeded(for category: MovieCategory, movie: Movie) {
        guard let index = movies.firstIndex(where: { $0.id == movie.id }), index >= movies.count - 5 else {
            return
        }
        loadMoviesByCategory(for: category)
    }
}
