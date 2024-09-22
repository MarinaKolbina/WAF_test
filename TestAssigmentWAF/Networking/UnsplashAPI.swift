//  UnspashAPI.swift
//  TestAssignmentWAF
//
//  Created by Marina Kolbina on 14/09/2024.
//

import Alamofire
import UIKit

struct UnsplashAPI {
    private static let accessKey = Constants.unsplashAccessKey
    private static let baseUrl = "https://api.unsplash.com/"
    
    static func fetchPhotos(query: String = "", count: Int = 30, session: Session = AF, completion: @escaping (Result<[Photo], Error>) -> Void) {
        let endpoint = query.isEmpty
        ? "photos/random?count=\(count)"
        : "photos/random?count=\(count)&query=\(query)"
        let url = baseUrl + endpoint
        
        let headers: HTTPHeaders = [
            "Authorization": "Client-ID \(accessKey)"
        ]
        
        session.request(url, headers: headers).responseData { response in
            guard let statusCode = response.response?.statusCode else {
                completion(.failure(APIError.custom(message:"Unknown error occurred.")))
                return
            }
            
            // Handle 401 and 403 error for rate limiting or access issues
            if [401, 403].contains(statusCode) {
                if let data = response.data, let message = String(data: data, encoding: .utf8) {
                    completion(.failure(APIError.forbidden(message: message)))
                } else {
                    completion(.failure(APIError.forbidden(message: "Access forbidden. Please check your API key or rate limits.")))
                }
                return
            }
            
            switch response.result {
            case .success(let data):
                do {
                    // Check if the response contains an error message
                    if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                        completion(.failure(APIError.custom(message: apiError.errors.joined(separator: ","))))
                        return
                    }
                    
                    // Decode photos if no error
                    let decoder = JSONDecoder()
                    let photos = try decoder.decode([Photo].self, from: data)
                    completion(.success(photos))
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                    completion(.failure(APIError.decodingError(message: error.localizedDescription)))
                }
            case .failure(let error):
                print("Failed to fetch photos: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}

enum APIError: Error {
    case forbidden(message: String)
    case custom(message: String)
    case decodingError(message: String)
}

struct APIErrorResponse: Codable {
    let errors: [String]
}
