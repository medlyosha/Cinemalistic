//
//  SearchMovieView.swift
//  Cinemalistic
//
//  Created by Lesha Mednikov on 14.09.2023.
//


import SwiftUI

struct SearchCell: View {
    let movie: Movie
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/original\(movie.posterPath ?? "")"), placeholder: {
                ProgressView()
                    .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height / 5 )
            })
            .aspectRatio(contentMode: .fit)
            .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height / 5 )
            VStack(alignment: .leading) {
                Text(movie.title + "," + " " + (movie.releaseDate ?? "").prefix(4))
                    .font(.custom("Avenir Next", size: 17))
                    .foregroundColor(.white)
                
            }
        }
    }
}
struct SearchMovieView: View {
    @ObservedObject var viewModel = SearchMovieResult()
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(viewModel.movies) {
                            movie in
                            NavigationLink(destination: MovieCardView(movieID: movie.id)) {
                                SearchCell(movie: movie)
                            }
                        }
                    }
                }
                .background(Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)))
                if viewModel.searchText.isEmpty {
                    VStack {
                        Text(verbatim: "Search Cinemalistic")
                            .font(.custom("Avenir Next Bold", size: 17))
                            .foregroundColor(.white)
                        Text(verbatim: "Find movies, overviews, actors and rating.")
                            .font(.custom("Avenir Next", size: 17))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search")
        .font(.custom("Avenir Next", size: 17))
        .foregroundColor(.white)
        .background(Color( #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)))
        .onChange(of: viewModel.searchText) { newValue in
            if !newValue.isEmpty {
                viewModel.getMoviesBySearch(query: newValue)
                print(UIScreen.main.bounds.height)
            } else {
                viewModel.cancelSearch()
            }
        }
        .navigationBarHidden(true)
    }
}

struct SearchMovieView_Previews: PreviewProvider {
    static var previews: some View {
        SearchMovieView()
    }
}
