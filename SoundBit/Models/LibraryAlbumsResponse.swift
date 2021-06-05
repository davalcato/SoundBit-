//
//  LibraryAlbumsResponse.swift
//  SoundBit
//
//  Created by Daval Cato on 6/5/21.
//

import Foundation

struct LibraryAlbumsResponse: Codable {
    // Array of Playlist objects
    let items: [Album]
    
}
