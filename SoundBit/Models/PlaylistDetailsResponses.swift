//
//  PlaylistDetailsResponses.swift
//  SoundBit
//
//  Created by Daval Cato on 3/13/21.
//

import Foundation

struct PlaylistDetailsResponses: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let tracks: PlaylistTracksResponse
    
}

struct PlaylistTracksResponse: Codable {
    let items: [PlaylistItem]
    
}

struct PlaylistItem: Codable {
    let track: AudioTrack
    
}





