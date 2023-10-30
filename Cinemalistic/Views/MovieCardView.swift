//
//  MovieCardView.swift
//  Cinemalistic
//
//  Created by Lesha Mednikov on 14.08.2023.
//

import SwiftUI
import CoreData
import WebKit
struct MovieCardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var movieDetailsResult = MovieDetailsResult()
    @State private var showAlert = false
    let movieID: Int
    var body: some View {
            ScrollView(showsIndicators: false) {
                    VStack(alignment: .center, spacing: 15) {
                        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/original\(movieDetailsResult.movieCard.backdropPath ?? "")"), placeholder: {
                            Image(systemName: "film")
                                .resizable()
                        })
                        .aspectRatio(contentMode: .fit)
                        .ignoresSafeArea(.all)
                        .id(UUID())
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Text(movieDetailsResult.movieCard.title + "," + " " + (movieDetailsResult.movieCard.releaseDate ?? "Не указана").prefix(4))
                                        .font(.custom("Avenir Next Bold", size: 30))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Button(action: toggleSaveState) {
                                        Image(systemName: movieDetailsResult.isSaved ? "heart.fill" : "heart")
                                            .foregroundColor(movieDetailsResult.isSaved ? .pink : .blue)
                                            .font(.system(size: 22))
                                            .padding(.horizontal)
                                            .padding(.vertical, 5)
                                            .background(Color.white.opacity(0.1))
                                            .cornerRadius(8)
                                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                                    }
                                }
                                Text("\(movieDetailsResult.movieCard.genres?.map { $0.name }.joined(separator: ", ") ?? "")")
                                    .font(.custom("Avenir Next", size: 17))
                                    .foregroundColor(.white)
                                    Text("Runtime: \(movieDetailsResult.movieCard.runtime) min")
                                        .font(.custom("Avenir Next Ultra Light", size: 17))
                                        .foregroundColor(.white)
                                Text("\(movieDetailsResult.movieCard.tagline)")
                                    .font(.custom("Avenir Next Condensed", size: 17))
                                    .foregroundColor(.white)
                            }
                            .padding()
                    Text(movieDetailsResult.movieCard.overview)
                        .font(.custom("Avenir Next", size: 17))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        Text("TMDB: ⭐️ \(movieDetailsResult.movieCard.rating , specifier: "%.1f")")
                            .font(.custom("Avenir Next", size: 17))
                            .foregroundColor(.white)
                    Text("Budget: \(movieDetailsResult.movieCard.budget)$")
                        .font(.custom("Avenir Next", size: 17))
                        .foregroundColor(.white)
                }
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(movieDetailsResult.credits) {
                            credit in
                            VStack(alignment: .center, spacing: 10) {
                                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/original\(credit.profilePath ?? "")"), placeholder: {
                                    Image(systemName: "film")
                                        .resizable()
                                })
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.height / 6)
                                Text(credit.name)
                                    .font(.custom("Avenir Next", size: 14))
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width / 3)
                                    .lineLimit(1)
                                Text("«\(credit.character)»")
                                    .font(.custom("Avenir Next Condensed", size: 14))
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width / 3 )
                                    .lineLimit(1)
                            }
                            .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height / 4)
                        }
                    }
                }
                .padding(15)
                ForEach(movieDetailsResult.trailers) { trailer in
                    VideoView(videoID: trailer.key)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 4)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                Button(action: {
                }) {
                    NavigationLink(destination: ReviewView(movieDetailsResult: movieDetailsResult)) {
                        Text("Reviews ")
                            .font(.custom("Avenir Next Bold", size: 17))
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    }
                }
                .padding()
                if let homepage =  movieDetailsResult.movieCard.homePage, homepage != "" {
                    Link("🔗 Visit Homepage", destination: URL(string: homepage)!)
                        .font(.custom("Avenir Next", size: 20))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
//                        .padding()
                }
            }
            .onAppear {
                movieDetailsResult.getMovieDetails(for: movieID)
                if movieDetailsResult.networkError != nil {
                       showAlert = true
                   }
            }
            .onReceive(movieDetailsResult.$networkError) { error in
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
            .onDisappear {
                movieDetailsResult.trailers = []
            }
            .background(Color( #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)))
        }
    private func toggleSaveState() {
        if movieDetailsResult.isSaved {
            PersistenceController.shared.deleteMovie(id: $movieDetailsResult.movieCard.id)
        } else {
            PersistenceController.shared.saveMovie(movie: movieDetailsResult.movieCard)
        }
        movieDetailsResult.isSaved.toggle()
    }
}

    struct MovieCardView_Previews: PreviewProvider {
        static var previews: some View {
            MovieCardView(movieID: 603)
        }
    }
