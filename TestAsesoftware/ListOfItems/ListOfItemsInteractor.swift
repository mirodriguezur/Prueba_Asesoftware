//
//  ListOfItemsInteractor.swift
//  TestAsesoftware
//
//  Created by Michael Alexander Rodriguez Urbina on 2/02/24.
//

import Foundation

public enum LoadResult {
    case success([ItemEntity])
    case failure(LoadError)
}

public enum LoadError: Swift.Error {
    case connectivity
    case invalidData
}

public enum CheckFromCacheResult {
    case empty
    case found(item: [ItemEntity])
    case failures(CacheError)
}

public enum CacheError: Swift.Error {
    case unablePerformRetrieval
    case unableSaveData
}

protocol ListOfItemsInteractorInput {
    func getListOfItems(completion: @escaping (LoadResult) -> Void)
    func checkListOfItemsFromCache(completion: @escaping (CheckFromCacheResult) -> Void)
    func requestSaveItemsOnCache(item: [ItemEntity], completion: @escaping (Error?) -> Void)
}

class ListOfItemsInteractor: ListOfItemsInteractorInput {
    static let urlApi = "https://jsonplaceholder.typicode.com/photos"
    static let urlStore = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("item.store")
    
    var dataSource: [ItemEntity]?
    let remoteListOfItemsLoader: RemoteListOfItemsLoader
    let cacheListOfItemsLoader: CacheListOfItemsLoader
    
    init(remoteListOfItemsLoader: RemoteListOfItemsLoader = RemoteListOfItemsLoader(url: URL(string: ListOfItemsInteractor.urlApi)!), 
         cacheListOfItemsLoader: CacheListOfItemsLoader = CacheListOfItemsLoader(store: ItemStore(storeURL: urlStore))){
        self.remoteListOfItemsLoader = remoteListOfItemsLoader
        self.cacheListOfItemsLoader = cacheListOfItemsLoader
    }
    
    func getListOfItems(completion: @escaping (LoadResult) -> Void) {
        remoteListOfItemsLoader.load { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success(items):
                completion(.success(items.toLocal()))
                break
            case let .failure(error):
                if error == .connectivity {
                    completion(.failure(.connectivity))
                } else {
                    completion(.failure(.invalidData))
                }
            }
        }
    }
    
    func checkListOfItemsFromCache(completion: @escaping (CheckFromCacheResult) -> Void) {
        cacheListOfItemsLoader.load { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success(items):
                if items.isEmpty {
                    completion(.empty)
                }
                completion(.found(item: items.toLocal()))
            case .failure:
                completion(.failures(.unablePerformRetrieval))
            }
        }
    }
    
    func requestSaveItemsOnCache(item: [ItemEntity], completion: @escaping (Error?) -> Void) {
        cacheListOfItemsLoader.save(item.toModel()) { error in
            completion(error)
        }
    }
}

private extension Array where Element == Item {
    func toLocal() -> [ItemEntity] {
        return map { ItemEntity(albumId: $0.albumId,
                                id: $0.id,
                                title: $0.title,
                                url: $0.url,
                                thumbnailUrl: $0.thumbnailUrl) }
    }
}

private extension Array where Element == ItemEntity {
    func toModel() -> [Item] {
        return map { Item(albumId: $0.albumId,
                          id: $0.id,
                          title: $0.title,
                          url: $0.url,
                          thumbnailUrl: $0.thumbnailUrl)}
    }
}
