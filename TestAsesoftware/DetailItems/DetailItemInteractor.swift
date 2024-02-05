//
//  DetailItemInteractor.swift
//  TestAsesoftware
//
//  Created by Michael Alexander Rodriguez Urbina on 4/02/24.
//

import Foundation

class DetailItemInteractor {
    static let urlApi = "https://jsonplaceholder.typicode.com/photos/"
    private let remoteListOfItemsLoader: RemoteListOfItemsLoader
    
    init(remoteListOfItemsLoader: RemoteListOfItemsLoader = RemoteListOfItemsLoader(url: URL(string: urlApi)!)) {
        self.remoteListOfItemsLoader = remoteListOfItemsLoader
    }
    
    func requestDeleteItem(itemId id: Int, completion: @escaping(Bool) -> Void) {
        remoteListOfItemsLoader.deleteItem(withId: id) { successfulOperation in
            if successfulOperation {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
