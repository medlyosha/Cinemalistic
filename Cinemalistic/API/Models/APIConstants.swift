//
//  APIConstants.swift
//  Cinemalistic
//
//  Created by Lesha Mednikov on 05.10.2023.
//

import Foundation
struct APIConstants {
    static let baseURL = "https://api.themoviedb.org/3"
    static func movieListURL(category: MovieCategory, page: Int) -> URL? {
        let urlString = "\(baseURL)/movie/\(category.rawValue)?api_key=\(APIKey.apiKey)&page=\(page)"
            return URL(string: urlString)
        }
    static func searchMovieURL(query: String, page: Int) -> URL? {
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)/search/movie?api_key=\(APIKey.apiKey)&query=\(encodedQuery)&page=\(page)"
            return URL(string: urlString)
        }
    static func movieDetailsURL(movieID: Int) -> URL? {
        let urlString = "\(baseURL)/movie/\(movieID)?api_key=\(APIKey.apiKey)"
            return URL(string: urlString)
        }
}
