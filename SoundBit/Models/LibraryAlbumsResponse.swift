//
//  LibraryAlbumsResponse.swift
//  SoundBit
//
//  Created by Daval Cato on 6/16/21.
//

import Foundation

struct LibraryAlbumsResponse: Codable {
    // Array of Albums objects
    let items: [Album]
}
