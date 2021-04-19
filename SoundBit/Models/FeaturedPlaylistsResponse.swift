//
//  FeaturedPlaylistResponse.swift
//  SoundBit
//
//  Created by Daval Cato on 2/26/21.
//

import Foundation

struct FeaturedPlaylistsResponse: Codable {
    let playlists: PlaylistResponse
    
}

struct CategoryPlaylistsResponse: Codable {
    let playlists: PlaylistResponse
    
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}
struct User: Codable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
}






















