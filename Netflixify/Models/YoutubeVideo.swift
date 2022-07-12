//
//  YoutubeVideo.swift
//  Netflixify
//
//  Created by Nwachukwu Ejiofor on 12/07/2022.
//

import Foundation

struct YoutubeVideo: Codable {
    let items: [Video]
    let etag: String
    let kind: String
    let nextPageToken: String
}

struct Video: Codable {
    let id: VideoId
    let etag: String
    let kind: String
}

struct VideoId: Codable {
    let kind: String
    let videoId: String
}
