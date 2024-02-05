//
//  ItemStore.swift
//  TestAsesoftware
//
//  Created by Michael Alexander Rodriguez Urbina on 5/02/24.
//

import Foundation

public enum RetrieveCachedFeedResult {
    case empty
    case found(item: [Item])
    case failure(Error)
}

public protocol ItemStoreProtocol {
    typealias RetrievalCompletion = (RetrieveCachedFeedResult) -> Void
    func retrieve(completion: @escaping RetrievalCompletion)
    func insert(_ item: [Item], completion: @escaping (Error?) -> Void)
}
