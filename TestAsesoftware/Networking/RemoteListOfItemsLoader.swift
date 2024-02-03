//
//  RemoteListOfItemsLoader.swift
//  TestAsesoftware
//
//  Created by Michael Alexander Rodriguez Urbina on 2/02/24.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    public func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success(data, response))
            } else {
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        }.resume()
    }
}

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
