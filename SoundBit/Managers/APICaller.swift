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
    
    // MARK: Albums
    
    public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/albums/" + album.id),
            type: .GET)
        { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                // Unwrapped the data
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                // Try to convert data into a JSON object
                do {
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
//                        JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                    print(result)
                    completion(.success(result))
                }
                catch {
//                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: Playlists
    public func getPlaylistDetails(for playlist: Playlist, completion: @escaping (Result<PlaylistDetailsResponses, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/playlists/" + playlist.id),
            type: .GET)
        { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                // Unwrapped the data
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(PlaylistDetailsResponses.self, from: data)
//                        JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                    print(result)
                    completion(.success(result))
                }
                catch {
//                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    // MARK: Profile
    
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
    
    // MARK: BROWSE
    
    public func getNewReleases(completion: @escaping ((Result<NewReleasesResponse, Error>)) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=50"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                // Convert the data to actual JSON here
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getFeaturePlaylists(completion: @escaping ((Result<FeaturedPlaylistsResponse, Error>)) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=30"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                // Convert the data to actual JSON here
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    public func getRecommendations(genres: Set<String>, completion: @escaping ((Result<RecommedationsResponse, Error>)) -> Void) {
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations?limit=20&seed_genres=\(seeds)"),
                      type: .GET) { request in
            print(request.url?.absoluteString)
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                // Convert the data to actual JSON here
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(RecommedationsResponse.self, from: data)
                    print(result)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendedGenres(completion: @escaping ((Result<RecommendedGenresResponse, Error>)) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                // Convert the data to actual JSON here
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
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
    
    // MARK: - Category
    
    // Retrieve categories
    public func getCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/browse/categories?limit=50"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                // Validate the date
                guard let data = data, error == nil else {
                    
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                // Convert the data
                do {
                    let result = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                        
//                        JSONSerialization.jsonObject(
//                        with: data,
//                        options: .allowFragments)
//                    print(result.categories.items)
                    completion(.success(result.categories.items))
                    
                }
                catch {
//                    print(error.localizedDescription)
                    completion(.failure(error))
                    
                }
            }
            task.resume()
        }
    }
    
    public func getCategoryPlaylists(category: Category, completion: @escaping (Result<[Playlist], Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/browse/categories/\(category.id)/playlists?limit=50"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                // Validate the date
                guard let data = data, error == nil else {
                    
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                // Convert the data
                do {
                    let result = try
                        JSONDecoder().decode(CategoryPlaylistsResponse.self, from: data)
                    // Retrieve the playlist
                    let playlists = result.playlists.items
                    completion(.success(playlists))
                    
//                        JSONSerialization.jsonObject(
//                        with: data,
//                        options: .allowFragments)
//                    print(json)
                    
                }
                catch {
//                    print(error.localizedDescription)
                    completion(.failure(error))
                    
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Search
    public func search(with query: String, completion: @escaping (Result<[String], Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL+"/search?limit=10&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"),
            type: .GET
        ) { request in
            print(request.url?.absoluteString ?? "none")
            
            let task = URLSession.shared.dataTask(
                with: request) { data, _, error in
                guard let data = data, error == nil else {
                    // If any of these cases don't hold up then
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                // Otherwise we convert into JSON
                do {
                    let result = try JSONDecoder().decode(SearchResultsResponse.self, from: data)
                        
//                        JSONSerialization.jsonObject(
//                        with: data,
//                        options: .allowFragments)
                    print(result)
                }
                catch {
                    print(error.localizedDescription)
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












