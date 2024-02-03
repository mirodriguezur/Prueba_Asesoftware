//
//  Item.swift
//  TestAsesoftware
//
//  Created by Michael Alexander Rodriguez Urbina on 3/02/24.
//

import Foundation

public struct Item: Decodable, Equatable {
    public let albumId: Int
    public let id: Int
    public let title: String
    public let url: URL
    public let thumbnailUrl: URL
    
    public init(albumId: Int, id: Int, title: String, url: URL, thumbnailUrl: URL) {
        self.albumId = albumId
        self.id = id
        self.title = title
        self.url = url
        self.thumbnailUrl = thumbnailUrl
    }
}
