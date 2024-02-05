//
//  ItemStore.swift
//  TestAsesoftware
//
//  Created by Michael Alexander Rodriguez Urbina on 5/02/24.
//

import Foundation

public class ItemStore: ItemStoreProtocol {
    
    private let storeURL: URL
    
    public init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        guard let data = try? Data(contentsOf: self.storeURL) else {
            return completion(.empty)
        }
        
        do {
            let decoder = JSONDecoder()
            let cache = try decoder.decode([Item].self, from: data)
            completion(.found(item: cache))
        } catch {
            completion(.failure(error))
        }
    }
    
    public func insert(_ item: [Item], completion: @escaping (Error?) -> Void) {
        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(item)
            try encoded.write(to: storeURL)
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    
}
