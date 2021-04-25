//
//  SearchResults.swift
//  SoundBit
//
//  Created by Daval Cato on 4/25/21.
//

import Foundation

// Maintain different search results
enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
    
}









