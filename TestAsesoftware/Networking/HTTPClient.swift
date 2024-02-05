//
//  HTTPClient.swift
//  TestAsesoftware
//
//  Created by Michael Alexander Rodriguez Urbina on 3/02/24.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
    func deleteItem(from url: URL, withId itemId: Int, completion: @escaping (HTTPClientResult) -> Void)
}
