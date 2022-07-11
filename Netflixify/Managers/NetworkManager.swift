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
}

enum APIError: Error {
    case failedToGetData
}

class NetworkManager {
    static let instance = NetworkManager()
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/trending/all/day?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(TrendingMovies.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
