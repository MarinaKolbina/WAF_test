//
//  Photo.swift
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
    
    var isFavorite: Bool = false
    
    init(id: String, authorName: String, creationDate: String, location: String?, downloads: Int, imageUrl: String, thumbnailUrl: String, isFavorite: Bool = false) {
        self.id = id
        self.authorName = authorName
        self.creationDate = creationDate
        self.location = location
        self.downloads = downloads
        self.imageUrl = imageUrl
        self.thumbnailUrl = thumbnailUrl
        self.isFavorite = isFavorite
    }

    enum CodingKeys: String, CodingKey {
        case id
        case creationDate = "created_at"
        case downloads
        case urls
        case user
        case location
        case isFavorite
    }

    enum UrlsKeys: String, CodingKey {
        case regular
        case thumb
    }
    
    enum UserKeys: String, CodingKey {
        case name
    }
    
    enum LocationKeys: String, CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        creationDate = try container.decode(String.self, forKey: .creationDate)
        downloads = try container.decode(Int.self, forKey: .downloads)
        
        let urlsContainer = try container.nestedContainer(keyedBy: UrlsKeys.self, forKey: .urls)
        imageUrl = try urlsContainer.decode(String.self, forKey: .regular)
        thumbnailUrl = try urlsContainer.decode(String.self, forKey: .thumb)
        
        let userContainer = try container.nestedContainer(keyedBy: UserKeys.self, forKey: .user)
        authorName = try userContainer.decode(String.self, forKey: .name)
        
        if let locationContainer = try? container.nestedContainer(keyedBy: LocationKeys.self, forKey: .location) {
            location = try locationContainer.decodeIfPresent(String.self, forKey: .name)
        } else {
            location = nil
        }
        
        isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
    }
    
    // Custom Encoder to handle nested JSON
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(downloads, forKey: .downloads)
        
        var urlsContainer = container.nestedContainer(keyedBy: UrlsKeys.self, forKey: .urls)
        try urlsContainer.encode(imageUrl, forKey: .regular)
        try urlsContainer.encode(thumbnailUrl, forKey: .thumb)
        
        var userContainer = container.nestedContainer(keyedBy: UserKeys.self, forKey: .user)
        try userContainer.encode(authorName, forKey: .name)
        
        if let location = location {
            var locationContainer = container.nestedContainer(keyedBy: LocationKeys.self, forKey: .location)
            try locationContainer.encode(location, forKey: .name)
        }
        
        try container.encode(isFavorite, forKey: .isFavorite)
    }
}
