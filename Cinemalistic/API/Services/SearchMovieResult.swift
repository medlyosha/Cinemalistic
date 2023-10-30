//
//  SearchMovieResult.swift
//  Cinemalistic
//
//  Created by Lesha Mednikov on 25.09.2023.
//

import Foundation
import Combine
class SearchMovieResult: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var searchText: String = ""
    private var cancellables: Set<AnyCancellable> = []
    private var searchCancellable: AnyCancellable?
    var currentPage = 1
    private var totalPages = 1
    private var isLoading = false
    func getMoviesBySearch(query: String) {
        guard !query.isEmpty else {
            cancelSearch()
            return
        }
        currentPage = 1
        movies.removeAll()
        searchText = query
        guard currentPage <= totalPages else {
            return
        }
        isLoading = true
        let encodedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = APIConstants.searchMovieURL(query: query, page: currentPage) else {
            return
        }
        searchCancellable?.cancel()
        searchCancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: MovieApiResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isLoading = false
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] response in
                self?.movies.append(contentsOf: response.results)
                self?.currentPage += 1
            })
    }
    func loadNextPageIfNeeded(for category: MovieCategory, movie: Movie) {
        guard let index = movies.firstIndex(where: { $0.id == movie.id }), index >= movies.count - 5 else {
            return
        }
        getMoviesBySearch(query: searchText)
    }
    func cancelSearch() {
        searchText = ""
        currentPage = 1
        movies.removeAll()
        searchCancellable?.cancel()
        isLoading = false
    }
}
