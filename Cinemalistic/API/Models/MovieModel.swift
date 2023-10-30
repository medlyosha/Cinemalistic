//
//  Movie.swift
//  Cinemalistic
//
//  Created by Lesha Mednikov on 14.08.2023.
//

import Foundation
struct MovieApiResponse: Codable {
    let results: [Movie]
    let total_pages: Int
}
struct TrailerApiResponse: Codable {
    let id: Int
    let results: [Trailer]
}
struct ReviewApiResponse: Codable {
    let id: Int
    let results: [Review]
    let page: Int
    let total_pages: Int
}
struct CastApiResponse: Codable {
    let id: Int
    let cast: [Cast]
    let crew: [Crew]
}
struct Movie: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String?
    let backdropPath: String?
    let genreIds: [Int]?
    let rating: Double
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case genreIds = "genre_ids"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case backdropPath = "backdrop_path"
        case rating = "vote_average"
    }
}
struct Review: Codable, Identifiable, Equatable {
    let id: String
    let author: String
    let content: String
}
struct Cast: Codable, Identifiable, Equatable {
    let name: String
    let id: Int
    let profilePath: String?
    let character: String
    let knownForDepartment: String
    enum CodingKeys: String, CodingKey {
        case name, id, character
        case profilePath = "profile_path"
        case knownForDepartment = "known_for_department"
    }
}
struct Crew: Codable, Identifiable, Equatable  {
    let name: String
    let id: Int
    let job: String
    let knownForDepartment: String
    enum CodingKeys: String, CodingKey {
        case name, id, job
        case knownForDepartment = "known_for_department"
    }
}
struct Genre: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
}
struct Trailer: Codable, Identifiable,  Equatable {
    let id: String
    let name: String
    let key: String
    let site: String
    let type: String
    let official: Bool
    let publishedAt: String
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case key
        case site
        case type
        case official
        case publishedAt = "published_at"
    }
}
struct MovieCard: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String?
    let backdropPath: String?
    let budget: Int
    let runtime: Int
    let genres: [Genre]?
    let homePage: String?
    let rating: Double
    let tagline: String
    enum CodingKeys: String, CodingKey {
        case id, overview,tagline, budget, runtime, genres
        case title = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case backdropPath = "backdrop_path"
        case rating = "vote_average"
        case homePage = "homepage"
    }
}
enum MovieCategory: String, CaseIterable {
    case nowPlaying = "now_playing"
    case popular = "popular"
    case upcoming = "upcoming"
    case topRated = "top_rated"
}
