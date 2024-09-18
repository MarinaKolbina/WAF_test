//
//  MockURLProtocol.swift
//  TestAssigmentWAFTests
//
//  Created by Marina Kolbina on 18/09/2024.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var mockResponseHandler: ((URLRequest) -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.mockResponseHandler else {
            return
        }
        
        let (response, data) = handler(request)
        
        if let data = data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        // No need to implement
    }
}
