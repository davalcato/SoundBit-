//
//  AllCategoriesResponse.swift
//  SoundBit
//
//  Created by Daval Cato on 4/18/21.
//

import Foundation


struct AllCategoriesResponse: Codable {
    let categories: Categories

}

struct Categories: Codable {
    let items: [Category]
    
}

struct Category: Codable {
    let id: String
    let name: String
    let icons: [APIImage]
    
}








