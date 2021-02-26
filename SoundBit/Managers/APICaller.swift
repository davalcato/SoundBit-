//
//  APICaller.swift
//  SoundBit
//
//  Created by Daval Cato on 2/20/21.
//

import Foundation
// Class responsible for making all the API calls
final class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
        
    }
    
    // Create custom errors here
    enum APIError: Error {
        case failedToGetData
    }
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/me"),
            type: .GET
        ) { baseRequest in
            // Execute request here
            let task = URLSession.shared.dataTask(with: baseRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    
                    return
                }
                // If we successfully get Data convert it JSON
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    print(result)
                     completion(.success(result))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                    
                }
            }
            task.resume()
        }
    }
    
    public func getNewReleases(completion: @escaping ((Result<String, Error>)) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=50"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                // Convert the data to actual JSON here
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(json)
                    
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Private
    
    enum HTTPMethod: String {
        case GET
        case POST
        
    }
    
    private func createRequest(
        with url: URL?,
        type: HTTPMethod,
        completion: @escaping (URLRequest) -> Void) {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            // Make the request generic here
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            
            completion(request)
        }
    }
}












