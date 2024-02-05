//
//  CacheListOfItemsLoader.swift
//  TestAsesoftware
//
//  Created by Michael Alexander Rodriguez Urbina on 5/02/24.
//

import Foundation

public class CacheListOfItemsLoader {
    private let store: ItemStoreProtocol
    
    public enum Error: Swift.Error {
        case unablePerformRetrieval
        case unableSaveData
    }
    
    public enum LoadItemResult: Equatable {
        case success([Item])
        case failure(Error)
    }
    
    public init(store: ItemStoreProtocol) {
        self.store = store
    }
    
    public func load(completion: @escaping (LoadItemResult) -> Void) {
        store.retrieve { result in
            switch result {
            case .failure:
                completion(.failure(.unablePerformRetrieval))
            case .empty:
                completion(.success([]))
            case let .found(item: item):
                completion(.success(item))
            }
        }
    }
    
    public func save(_ item: [Item], completion: @escaping (Error?)-> Void) {
        store.insert(item) {  error in
            guard error != nil else {
                return completion(nil)
            }
            completion(.unableSaveData)
        }
    }
}
