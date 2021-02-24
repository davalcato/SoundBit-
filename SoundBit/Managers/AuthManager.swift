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
        static let redirectURI = "https://www.iosacademy.io"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    
    }
    
    private init() {}
    
    public var signInURL: URL? {
        
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.ClientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool? {
        guard let expirationDate = tokenExpirationDate else {
            // If expirationDate in nil return false
            return false
            
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    public func exchangeCodeForToken(
        code: String,
        completion: @escaping ((Bool) -> Void)
    
        ) {
        // Get Token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            
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
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data,
                  error == nil else {
                // If something goes wrong here
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            }
            
            catch {
                print(error.localizedDescription)
                completion(false)
                
            }
        }
        task.resume()
    }
    
    public func refreshIfNeeded(completion: @escaping (Bool) -> Void) {
//        guard shouldRefreshToken! else {
//            completion(true)
//            return
//        }
        
        guard let refreshToken = self.refreshToken else {
            
            return
        }
        
        // Refresh the token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
            
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
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data,
                  error == nil else {
                // If something goes wrong here
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                print("Successfully refreshed")
                self?.cacheToken(result: result)
                completion(true)
            }
            
            catch {
                print(error.localizedDescription)
                completion(false)
                
            }
        }
        task.resume()
        
    }
    
    // Here we cache token
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
        
        
    }
}








