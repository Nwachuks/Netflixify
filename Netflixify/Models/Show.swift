//
//  Show.swift
//  Netflixify
//
//  Created by Nwachukwu Ejiofor on 11/07/2022.
//

import Foundation

struct ShowCategory: Codable {
    let results: [Show]
}

struct Show: Codable {
    let id: Int
    let mediaType: String?
    let originalName: String?
    let originalTitle: String?
    let posterPath: String?
    let overview: String?
    let voteCount: Int?
    let voteAverage: Double?
    let releaseDate: String?
    
    enum CodingKeys : String, CodingKey {
        case id
        case mediaType = "media_type"
        case originalName = "original_name"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case overview
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }
}
