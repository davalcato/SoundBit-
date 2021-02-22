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
    
    public var signInURL: URL? {
        let scopes = "user-read-private"
        let redirectURI = "https://www.iosacademy.io"
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.ClientID)&scope=\(scopes)&redirect_uri=\(redirectURI)"
        return URL(string: string)
    }
    
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








