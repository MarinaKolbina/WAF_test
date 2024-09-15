//
//  Network.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 14/09/2024.
//

import Foundation

struct UnsplashAPI {
    private static let accessKey = "YOUR_UNSPLASH_ACCESS_KEY"
    private static let baseUrl = "https://api.unsplash.com/"
    
    static func fetchPhotos(query: String = "", completion: @escaping ([Photo]) -> Void) {
        let endpoint = query.isEmpty ? "photos/random?count=30" : "search/photos?query=\(query)&per_page=30"
        guard let url = URL(string: baseUrl + endpoint) else { return }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch photos: \(error?.localizedDescription ?? "No error description")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                if query.isEmpty {
                    let photos = try decoder.decode([Photo].self, from: data)
                    completion(photos)
                } else {
                    let searchResponse = try decoder.decode(PhotoSearchResponse.self, from: data)
                    completion(searchResponse.results)
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
