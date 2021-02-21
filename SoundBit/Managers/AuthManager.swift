//
//  AuthManager.swift
//  SoundBit
//
//  Created by Daval Cato on 2/20/21.
//

import Foundation

// Create an Auth object here
final class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    var isSignedIn: Bool {
        
        return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldrefreshToken: Bool? {
        return false
        
    }
}








