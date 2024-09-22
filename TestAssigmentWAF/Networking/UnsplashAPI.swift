//  Network.swift
//  TestAssignmentWAF
//
//  Created by Marina Kolbina on 14/09/2024.
//

import Alamofire
import UIKit

struct UnsplashAPI {
    private static let accessKey = Constants.unsplashAccessKey
    private static let baseUrl = "https://api.unsplash.com/"
    
    static func fetchPhotos(query: String = "", count: Int = 30, session: Session = AF, completion: @escaping ([Photo]) -> Void) {
        let endpoint = query.isEmpty
            ? "photos/random?count=\(count)"
            : "search/photos?query=\(query)&per_page=\(count)"
        let url = baseUrl + endpoint
        
        let headers: HTTPHeaders = [
            "Authorization": "Client-ID \(accessKey)"
        ]
        
        session.request(url, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
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
                    showAlert(with: "Decoding Error", message: error.localizedDescription)
                    
                    completion([])
                }
            case .failure(let error):
                print("Failed to fetch photos: \(error.localizedDescription)")
                showAlert(with: "Network Error", message: error.localizedDescription)
                
                completion([])
            }
        }
    }
    
    // Function to show alerts
    private static func showAlert(with title: String, message: String) {
        guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = scene.windows.first(where: { $0.isKeyWindow }),
              let topViewController = window.rootViewController else {
            return
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }
}
