//
//  MustWatchView.swift
//  Cinemalistic
//
//  Created by Lesha Mednikov on 20.08.2023.
//

import SwiftUI
import CoreData

struct MustWatchView: View {
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(
        entity: MovieEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \MovieEntity.title, ascending: true)]
    )
    private var savedMovies: FetchedResults<MovieEntity>
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(savedMovies, id: \.self) { savedMovie in
                        NavigationLink(destination: MovieCardView(movieID: Int(savedMovie.id))) {
                        VStack {
                            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/original\(savedMovie.posterPath ?? "")"), placeholder: {
                                Image(systemName: "film")
                                    .resizable()
                            })
                            .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height / 4)
                            .scaledToFit()
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                            
                            Text(savedMovie.title ?? "Название не указано")
                                .font(.custom("Avenir Next Bold", size: 16))
                                .foregroundColor(.white)
                            
                            Text((savedMovie.releaseDate ?? "Не указано").prefix(4))
                                .font(.custom("Avenir Next Regular", size: 14))
                                .foregroundColor(.gray)
                        }
                        .frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.height / 3)
                        .padding(.all, 10)
                        .background(Color( #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)))
                        .cornerRadius(8)
                        .contextMenu {
                            Button(action: {
                                PersistenceController.shared.deleteMovie(id: Int(savedMovie.id))
                            }) {
                                Text("Delete")
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                        }
                    }
                        
                }
                .padding()
            }
            .background(Color( #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)))
            .navigationBarTitle("Must watch")
            if savedMovies.isEmpty {
                VStack {
                    Text(verbatim: "Must Watch Cinemalistic")
                        .font(.custom("Avenir Next Bold", size: 17))
                        .foregroundColor(.white)
                    Text(verbatim: "Save the movies you want to watch")
                        .font(.custom("Avenir Next Regular", size: 17))
                        .foregroundColor(.white)
                }
            }
        }
    }
}
struct MustWatchView_Previews: PreviewProvider {
    static var previews: some View {
        MustWatchView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
