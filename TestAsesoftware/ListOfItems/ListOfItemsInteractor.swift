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

protocol ListOfItemsInteractorInput {
    func getListOfItems(completion: @escaping (LoadResult) -> Void)
}

class ListOfItemsInteractor: ListOfItemsInteractorInput {
    var dataSource: [ItemEntity]?
    let remoteListOfItemsLoader: RemoteListOfItemsLoader
    
    init(remoteListOfItemsLoader: RemoteListOfItemsLoader = RemoteListOfItemsLoader(url: URL(string: "https://jsonplaceholder.typicode.com/photos")!)){
        self.remoteListOfItemsLoader = remoteListOfItemsLoader
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
