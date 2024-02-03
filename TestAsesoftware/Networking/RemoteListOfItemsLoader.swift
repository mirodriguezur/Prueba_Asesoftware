//
//  RemoteListOfItemsLoader.swift
//  TestAsesoftware
//
//  Created by Michael Alexander Rodriguez Urbina on 2/02/24.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
}

public class RemoteListOfItemsLoader {
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func loader() {
        client.get(from: url)
    }
}
