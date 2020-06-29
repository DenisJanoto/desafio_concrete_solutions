//
//  GetResponse.swift
//  DesafioConcreteSolutions
//
//  Created by Denis Janoto on 08/06/20.
//  Copyright © 2020 Denis Janoto. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct GetResponse: Codable {
    let page, totalResults, totalPages: Int
    let results: [Result]

    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Result
struct Result: Codable {
    var popularity: Double = 0.0
    var voteCount: Int = 0
    var video: Bool = false
    var posterPath: String = ""
    var id: Int = 0
    var adult: Bool = false
    var originalTitle: String = ""
    var genreIDS: [Int]=[]
    var title: String = ""
    var voteAverage: Double = 0.0
    var overview, releaseDate: String?

    enum CodingKeys: String, CodingKey {
        case popularity
        case voteCount = "vote_count"
        case video
        case posterPath = "poster_path"
        case id, adult
        case originalTitle = "original_title"
        case genreIDS = "genre_ids"
        case title
        case voteAverage = "vote_average"
        case overview
        case releaseDate = "release_date"
    }
}


