//
//  ReviewView.swift
//  Cinemalistic
//
//  Created by Lesha Mednikov on 02.10.2023.
//

import SwiftUI

struct ReviewView: View {
    var movieDetailsResult: MovieDetailsResult
    var body: some View {
        Text("Reviews")
            .font(.custom("Avenir Next Bold", size: 30))
            .foregroundColor(.white)
        List {
            ForEach(movieDetailsResult.reviews) {
                review in
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(review.content)
                            .font(.custom("Avenir Next", size: 17))
                            .foregroundColor(.white)
                        Text("By \(review.author)")
                            .font(.custom("Avenir Next Ultra Light", size: 17))
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 8)
                }
                .listRowSeparator(.hidden)
                .background(Color( #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)))
                .listRowInsets(EdgeInsets())
                .cornerRadius(10)
                .shadow(radius: 3)
                .padding(.horizontal, 16)
            }
        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(movieDetailsResult: MovieDetailsResult())
    }
}
