//
//  MoviesView.swift
//  Cinemalistic
//
//  Created by Lesha Mednikov on 14.08.2023.
//


import SwiftUI

struct MovieCell: View {
    let movie: Movie
    var body: some View {
        VStack {
            GeometryReader { geometry in
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/original\(movie.posterPath ?? "")"), placeholder: {
                    ProgressView()
                    Image(systemName: "film")
                        .resizable()
                })
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
            .clipShape(RoundedRectangle(cornerRadius: 20))
                .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX) - 210) / -30), axis: (x: 0, y: 1.0, z: 0))
            }
            
            .frame(width: UIScreen.main.bounds.width / 1.5, height: UIScreen.main.bounds.height / 2 )
            .aspectRatio(contentMode: .fill)
            .padding(.top, 10)
            Text(movie.title + "," + " " + (movie.releaseDate ?? "").prefix(4))
                .font(.custom("Avenir Next", size: 17))
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width)
                .padding(.top, 10)
        }
        .padding(.vertical)
    }
}

struct MoviesView: View {
    @ObservedObject var viewModel = MoviesCategoriesResult()
    @State private var selectedCategory: MovieCategory = .nowPlaying
    @State private var showAlert = false
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .center) {
                    LazyVGrid(columns: [
                        GridItem(.flexible(minimum: 0, maximum: .infinity)),
                        GridItem(.flexible(minimum: 0, maximum: .infinity))
                    ], spacing: 16) {
                        ForEach(MovieCategory.allCases, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                                viewModel.currentPage = 1
                                viewModel.movies = []
                                viewModel.loadMoviesByCategory(for: category)
                            }) {
                                Text(category.rawValue.capitalized.replacingOccurrences(of: "_", with: " "))
                                    .font(.custom("Avenir Next", size: 17))
                                    .foregroundColor(selectedCategory == category ? .white : .white)
                                    .frame(width: UIScreen.main.bounds.width / 2.4, height: UIScreen.main.bounds.height / 35)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 10)
                                    .background(selectedCategory == category ? Color(.systemBlue) : Color( #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)))
                                    .cornerRadius(15)
                            }
                        }
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(alignment: .center) {
                            ForEach(viewModel.movies) { movie in
                                NavigationLink(destination: MovieCardView(movieID: movie.id)) {
                                    MovieCell(movie: movie)
                                }
                                .onAppear {
                                    viewModel.loadNextPageIfNeeded(for: selectedCategory, movie: movie)
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    viewModel.loadMoviesByCategory(for: selectedCategory)
                    if viewModel.networkError != nil {
                           showAlert = true
                       }
                }
                .onReceive(viewModel.$networkError) { error in
                            if error != nil {
                                showAlert = true
                            }
                        }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Network error"),
                        message: Text("No network connection. Please make sure you have access to the internet and try again."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .padding(.top, 10)
            .background(Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)))
        }
    }
}
struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
    }
}


