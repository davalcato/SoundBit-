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
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        
    
    }
    
    private init() {}
    
    public var signInURL: URL? {
        let scopes = "user-read-private"
        let redirectURI = "https://www.iosacademy.io"
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.ClientID)&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
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
    
    public func exchangeCodeForToken(
        code: String,
        completion: @escaping ((Bool) -> Void)
    
        ) {
        // API call to get token here
        guard let url = URL(string: Constants.tokenAPIURL) else {
            
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: "code"),
            URLQueryItem(name: "redirect_uri", value: "https://www.iosacademy.io"),
            
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.ClientID+":"+Constants.ClientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            
            print("Failure to get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data,
                  error == nil else {
                // If something goes wrong here
                completion(false)
                
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(
                    with: data, options: .allowFragments)
                
                print("SUCCESS: \(json)")
                completion(true)
            }
            
            catch {
                print(error.localizedDescription)
                completion(false)
                
            }
        }
        task.resume()
    }
    
    public func refreshAccessToken() {
        
        
    }
    
    // Here we cache token
    private func cacheToken() {
        
    }
}








