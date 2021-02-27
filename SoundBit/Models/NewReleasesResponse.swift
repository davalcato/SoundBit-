//
//  NewReleaseResponse.swift
//  SoundBit
//
//  Created by Daval Cato on 2/25/21.
//

import Foundation

struct NewReleasesResponse: Codable {
    // Root key here
    let albums: AlbumsResponse
    
}

struct AlbumsResponse: Codable {
    let items: [Album]
    
}

struct Album: Codable {
    let album_type: String
    let available_markets: [String]
    let id: String
    let images: [APIImage]
    let name: String
    let release_date: String
    let total_tracks: Int
    let artists: [Artist]
}
















