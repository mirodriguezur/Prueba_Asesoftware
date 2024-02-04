//
//  RemoteListOfItemsLoader.swift
//  TestAsesoftware
//
//  Created by Michael Alexander Rodriguez Urbina on 2/02/24.
//

import Foundation

public class RemoteListOfItemsLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([Item])
        case failure(Error)
    }
    
    public init(url: URL, client: HTTPClient = URLSessionHTTPClient()) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            
            guard self != nil else { return }
            
            switch result {
            case let .success(data, response):
                if response.statusCode == 200, let listOfItems = try? JSONDecoder().decode([Item].self, from: data) {
                    completion(.success(listOfItems))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
