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
    
    // Create function for getCurrentUserAlbums
    public func getCurrentUserAlbums(completion: @escaping (Result<[Album], Error>) -> Void) {
        // Create request
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/v1/me/albums"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                // Unwrapped the data
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(LibraryAlbumsResponse.self, from: data)
//                        JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(result)
                    // Array of albums 
                    completion(.success(result.items))
                }
                catch {
//                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // Save album API
    public func saveAlbum(album: Album, completion: @escaping (Bool) -> Void) {
        // Create request
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/me/albums?ids=\(album.id)"),
            type: .PUT) { baseRequest in
            var request = baseRequest
            request.setValue("application/json",
                             forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Unwrapped the data
                guard let data = data,
                      let code = (response as? HTTPURLResponse)?.statusCode,
                        error == nil else {
                    completion(false)
                    return
                }
                // Response status code
                print(code)
                    completion(code == 201)
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
    
    public func getCurrentUserPlaylists(completion: @escaping(Result<[Playlist], Error>) -> Void) {
        // Create a request
        createRequest(with: URL(string: Constants.baseAPIURL + "/me/playlists/?limit=50"),
                      type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(
                with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                // Decode the data back
                do {
                    // JSON to dump the data
                    let result = try JSONDecoder().decode(LibraryPlaylistsResponse.self, from: data)
                    completion(.success(result.items))
                    
//                        JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                    print(result)
                }
                // Incase something goes wrong
                catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
        
    }
    
    public func createPlaylist(with name: String, completion: @escaping(Bool) -> Void) {
        // Get the current user profile
        getCurrentUserProfile { [weak self] result in
            switch result {
            case .success(let profile):
                // Create the URL
                let urlString = Constants.baseAPIURL + "/users/\(profile.id)/playlists"
                // Add print statements
                print(urlString)
                // The other API call
                self?.createRequest(with: URL(
                                        string: urlString),
                                    type: .POST) { baseRequest in
                    // Mutable property
                    var request = baseRequest
                    
                    // Create the JSON
                    let json = [
                        "name": name
                    ]
                    // Create a dictionary
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                    print("Starting creation...")
                   // Create a task
                    let task = URLSession.shared.dataTask(with: request) { data, _, error in
                        guard let data = data, error == nil else {
                            // This completion is false
                            completion(false)
                            return
                        }
                        do {
                            // Get the JSON out
                            let result = try JSONSerialization.jsonObject(
                                with: data,
                                options: .allowFragments)
                            if let response = result as? [String: Any], response["id"] as? String != nil {
                                print("Created")
                                completion(true)
                                
                            }
                            else {
                                print("Failed to get id")
                                completion(false)
                            }
                        }
                        // If something fails
                        catch {
                            // Print out the error
                            print(error.localizedDescription)
                            completion(false)
                        }
                    }
                    task.resume()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                break
            
            }
        }
    }
    
    public func addTrackToPlaylist(
        // Pass in a track
        track: AudioTrack,
        // Pass in a Playlist
        playlist: Playlist,
        completion: @escaping(Bool) -> Void
    ) {
        // Create request
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/playlists/\(playlist.id)/tracks"),
            type: .POST
        ) { baseRequest in
            // Mutable copy
            var request = baseRequest
            // Create JSON Body
            let json = [
                "uris": [
                    "spotify:track:\(track.id)"
                ]
            ]
            print(json)
            // Set httpBody
            request.httpBody = try? JSONSerialization.data(
                withJSONObject: json,
                options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            print("Adding...")
            
            
            // Kick request off
            let task = URLSession.shared.dataTask(
                with: request) { data, _, error in
                // Unwrap the data
                guard let data = data, error == nil else {
                    // If any errors
                    completion(false)
                    return
                }
                
                do {
                    // decode result
                    let result = try JSONSerialization.jsonObject(
                        with: data,
                        options: .allowFragments)
                    // Print out request
                    print(result)
                    if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
                        // Call was successful
                        completion(true)
                    }
                    else {
                        print(result)
                        completion(false)
                    }
                }
                
                catch {
                    completion(false)
                    
                }
            }
            task .resume()
        }
    }
    
    public func removeTrackFromPlaylist(
        track: AudioTrack,
        playlist: Playlist,
        completion: @escaping(Bool) -> Void
    ) {
        // Create request
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/playlists/\(playlist.id)/tracks"),
            type: .DELETE
        ) { baseRequest in
            // Mutable copy
            var request = baseRequest
            // Create JSON Body
            let json = [
                "tracks": [
                    [
                        "uri": "spotify:track:\(track.id)"
                    ]
                ]
            ]
            // Set httpBody
            request.httpBody = try? JSONSerialization.data(
                withJSONObject: json,
                options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            // Kick request off
            let task = URLSession.shared.dataTask(
                with: request) { data, _, error in
                // Unwrap the data
                guard let data = data, error == nil else {
                    // If any errors
                    completion(false)
                    return
                }
                
                do {
                    // decode result
                    let result = try JSONSerialization.jsonObject(
                        with: data,
                        options: .allowFragments)
                    // Print out request
//                    print(result)
                    if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
                        // Call was successful
                        completion(true)
                    }
                    else {
//                        print(result)
                        completion(false)
                    }
                }
                
                catch {
                    completion(false)
                }
            }
            task .resume()
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
    public func search(with query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {
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
                    
                    var searchResults: [SearchResult] = []
                    // Convert all the tracks to one type here
                    searchResults.append(contentsOf: result.tracks.items.compactMap({ .track(model: $0) }))
                    searchResults.append(contentsOf: result.albums.items.compactMap({ .album(model: $0) }))
                    searchResults.append(contentsOf: result.artists.items.compactMap({ .artist(model: $0) }))
                    searchResults.append(contentsOf: result.playlists.items.compactMap({ .playlist(model: $0) }))
                    
                    
                    completion(.success(searchResults))
                    
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
        case PUT
        case POST
        case DELETE
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












