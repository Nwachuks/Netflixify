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
}
