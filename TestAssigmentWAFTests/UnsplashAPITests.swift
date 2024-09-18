//
//  UnsplashAPITests.swift
//  TestAssigmentWAFTests
//
//  Created by Marina Kolbina on 18/09/2024.
//

import Foundation
import Alamofire
import XCTest
@testable import TestAssigmentWAF

class UnsplashAPITests: XCTestCase {
    
    var mockSession: Session!

    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        
        mockSession = Session(configuration: configuration)
    }

    func testFetchPhotosSuccess() {
        let mockJSON = """
        [
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
                "isFavorite": false
            }
        ]
        """.data(using: .utf8)!
        
        MockURLProtocol.mockResponseHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, mockJSON)
        }
        
        let expectation = self.expectation(description: "Photos fetched successfully")
        
        UnsplashAPI.fetchPhotos(session: mockSession) { photos in
            XCTAssertEqual(photos.count, 1)
            XCTAssertEqual(photos.first?.id, "123")
            XCTAssertEqual(photos.first?.authorName, "Marina Kolbina")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchPhotosFailure() {
        MockURLProtocol.mockResponseHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 500,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, nil)
        }
        
        let expectation = self.expectation(description: "Photos fetch failed")
        
        UnsplashAPI.fetchPhotos(session: mockSession) { photos in
            XCTAssertEqual(photos.count, 0)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
