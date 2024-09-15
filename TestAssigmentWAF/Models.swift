//
//  Models.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 15/09/2024.
//

import UIKit

struct Photo: Codable {
    let id: String
    let authorName: String
    let creationDate: String
    let location: String?
    let downloads: Int
    let imageUrl: String
    let thumbnailUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case authorName = "user.name"
        case creationDate = "created_at"
        case location = "location.name"
        case downloads
        case imageUrl = "urls.regular"
        case thumbnailUrl = "urls.thumb"
    }
}

struct PhotoSearchResponse: Codable {
    let results: [Photo]
}
