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
    
    struct Constants {
        static let ClientID = "b29d5b04e2b74884af9de7a77903291f"
        
        static let ClientSecret = "67f0dbab601c43b4bc258bb19a0f0733"
    
    }
    
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








