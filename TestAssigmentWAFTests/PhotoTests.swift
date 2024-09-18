//
//  PhotoTests.swift
//  TestAssigmentWAFTests
//
//  Created by Marina Kolbina on 18/09/2024.
//

import XCTest
@testable import TestAssigmentWAF

class PhotoTests: XCTestCase {
    
    func testPhotoDecoding() throws {
        let json = """
        {
            "id": "123",
            "created_at": "2024-09-15",
            "downloads": 150,
            "urls": {
                "regular": "https://example.com/image.jpg",
                "thumb": "https://example.com/thumb.jpg"
            },
            "user": {
                "name": "Marina Kolbina"
            },
            "location": {
                "name": "San Francisco"
            },
            "isFavorite": true
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let photo = try decoder.decode(Photo.self, from: json)
        
        XCTAssertEqual(photo.id, "123")
        XCTAssertEqual(photo.creationDate, "2024-09-15")
        XCTAssertEqual(photo.downloads, 150)
        XCTAssertEqual(photo.imageUrl, "https://example.com/image.jpg")
        XCTAssertEqual(photo.thumbnailUrl, "https://example.com/thumb.jpg")
        XCTAssertEqual(photo.authorName, "Marina Kolbina")
        XCTAssertEqual(photo.location, "San Francisco")
        XCTAssertTrue(photo.isFavorite)
    }
    
    func testPhotoEncoding() throws {
        let photo = Photo(
            id: "123",
            authorName: "Marina Kolbina",
            creationDate: "2024-09-15",
            location: "San Francisco",
            downloads: 150,
            imageUrl: "https://example.com/image.jpg",
            thumbnailUrl: "https://example.com/thumb.jpg",
            isFavorite: true
        )
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let encodedData = try encoder.encode(photo)
        
        let json = String(data: encodedData, encoding: .utf8)!
        print(json)
        
        let decoder = JSONDecoder()
        let decodedPhoto = try decoder.decode(Photo.self, from: encodedData)
        
        XCTAssertEqual(decodedPhoto.id, photo.id)
        XCTAssertEqual(decodedPhoto.authorName, photo.authorName)
        XCTAssertEqual(decodedPhoto.creationDate, photo.creationDate)
        XCTAssertEqual(decodedPhoto.downloads, photo.downloads)
        XCTAssertEqual(decodedPhoto.imageUrl, photo.imageUrl)
        XCTAssertEqual(decodedPhoto.thumbnailUrl, photo.thumbnailUrl)
        XCTAssertEqual(decodedPhoto.location, photo.location)
        XCTAssertEqual(decodedPhoto.isFavorite, photo.isFavorite)
    }
    
    func testPhotoDecodingWithoutOptionalValues() throws {
        let json = """
        {
            "id": "123",
            "created_at": "2024-09-15",
            "downloads": 150,
            "urls": {
                "regular": "https://example.com/image.jpg",
                "thumb": "https://example.com/thumb.jpg"
            },
            "user": {
                "name": "Marina Kolbina"
            }
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let photo = try decoder.decode(Photo.self, from: json)
        
        XCTAssertEqual(photo.id, "123")
        XCTAssertEqual(photo.creationDate, "2024-09-15")
        XCTAssertEqual(photo.downloads, 150)
        XCTAssertEqual(photo.imageUrl, "https://example.com/image.jpg")
        XCTAssertEqual(photo.thumbnailUrl, "https://example.com/thumb.jpg")
        XCTAssertEqual(photo.authorName, "Marina Kolbina")
        
        XCTAssertNil(photo.location)
        XCTAssertFalse(photo.isFavorite)
    }
}
