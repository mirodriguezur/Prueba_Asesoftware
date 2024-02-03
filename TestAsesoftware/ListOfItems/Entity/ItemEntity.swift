//
//  ItemEntity.swift
//  TestAsesoftware
//
//  Created by Michael Alexander Rodriguez Urbina on 2/02/24.
//

import Foundation

public struct ItemEntity: Decodable, Equatable {
    let albumId: Int
    let id: Int
    let title: String
    let url: URL
    let thumbnailUrl: URL

    private enum CodingKeys: String, CodingKey {
        case albumId, id, title, url, thumbnailUrl
    }
}
