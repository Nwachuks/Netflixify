//
//  DataPersistenceManager.swift
//  Netflixify
//
//  Created by Nwachukwu Ejiofor on 12/07/2022.
//

import Foundation
import UIKit
import CoreData

enum DatabaseError: Error {
    case failedToSaveData
    case failedToGetData
    case failedToDeleteData
}

class DataPersistenceManager {
    
    static let instance = DataPersistenceManager()
    
    func downloadShow(using show: Show, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let item = ShowItem(context: context)
        item.id = Int64(show.id)
        item.originalTitle = show.originalTitle
        item.originalName = show.originalName
        item.posterPath = show.posterPath
        item.overview = show.overview
        item.mediaType = show.mediaType
        item.releaseDate = show.releaseDate
        item.voteCount = Int64(show.voteCount ?? 0)
        item.voteAverage = show.voteAverage ?? 0.0
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            print(error.localizedDescription)
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    func fetchShow(completion: @escaping (Result<[ShowItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<ShowItem>
        request = ShowItem.fetchRequest()
        
        do {
            let shows = try context.fetch(request)
            completion(.success(shows))
        } catch {
            print(error.localizedDescription)
            completion(.failure(DatabaseError.failedToGetData))
        }
    }
    
    func deleteShow(using show: ShowItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(show)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            print(error.localizedDescription)
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
}
