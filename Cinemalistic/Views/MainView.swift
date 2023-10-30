//
//  TabView.swift
//  Cinemalistic
//
//  Created by Lesha Mednikov on 14.08.2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            MoviesView()
                .tabItem {
                    Label("Movies", systemImage: "film.stack.fill")
                }
            SearchMovieView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            MustWatchView()
                .tabItem {
                    Label("Must watch", systemImage: "heart.fill")
                }
        }
    }
}
struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
