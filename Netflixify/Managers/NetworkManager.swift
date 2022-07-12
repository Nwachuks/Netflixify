//
//  NetworkManager.swift
//  Netflixify
//
//  Created by Nwachukwu Ejiofor on 09/07/2022.
//

import Foundation

struct Constants {
    static let API_KEY = "3c8f4ab5cc70f5ea365fde08e9972a69"
    static let BASE_URL = "https://api.themoviedb.org/3"
    static let IMAGE_BASE_URL = "https://image.tmdb.org/t/p/w500"
    static let YOUTUBE_API_KEY = "AIzaSyBQgbMvoYGSgtCBDqwxOy_Sp_DfHHN9CKI"
    static let YOUTUBE_SEARCH_BASE_URL = "https://youtube.googleapis.com/youtube/v3/search"
}

enum APIError: Error {
    case failedToGetData
}

class NetworkManager {
    static let instance = NetworkManager()
    
    func getPopularMovies(completion: @escaping (Result<[Show], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(ShowCategory.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getTrendingMovies(completion: @escaping (Result<[Show], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/trending/movie/day?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(ShowCategory.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getTrendingTVShows(completion: @escaping (Result<[Show], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/trending/tv/day?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(ShowCategory.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Show], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(ShowCategory.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getTopRatedMovies(completion: @escaping (Result<[Show], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(ShowCategory.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Show], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&page=1&sort_by=popularity.desc&include_adult=false&include_video=false&with_watch_monetization_types=flatrate") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(ShowCategory.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getSearchMovies(with query: String, completion: @escaping (Result<[Show], Error>) -> Void) {
        guard let queryParams = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.BASE_URL)/search/movie?api_key=\(Constants.API_KEY)&query=\(queryParams)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(ShowCategory.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getMovieFromYoubtube(using query: String, completion: @escaping (Result<Video, Error>) -> Void) {
        guard let queryParams = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.YOUTUBE_SEARCH_BASE_URL)?q=\(queryParams)&key=\(Constants.YOUTUBE_API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(YoutubeVideo.self, from: data)
                completion(.success(results.items[0]))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
}
