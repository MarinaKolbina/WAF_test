//
//  PersistanceManager.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 14/09/2024.
//

import Foundation

class PersistenceManager {
    static let shared = PersistenceManager()
    private let favoritesKey = "favoritePhotos"
    
    private init() {}
    
    func addFavorite(_ photo: Photo) {
        var favorites = getFavorites()
        favorites.append(photo)
        saveFavorites(favorites)
    }
    
    func removeFavorite(_ photo: Photo) {
        var favorites = getFavorites()
        favorites.removeAll { $0.id == photo.id }
        saveFavorites(favorites)
    }
    
    func getFavorites() -> [Photo] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey) else { return [] }
        do {
            let photos = try JSONDecoder().decode([Photo].self, from: data)
            return photos
        } catch {
            print("Failed to decode favorites: \(error.localizedDescription)")
            return []
        }
    }
    
    private func saveFavorites(_ photos: [Photo]) {
        do {
            let data = try JSONEncoder().encode(photos)
            UserDefaults.standard.set(data, forKey: favoritesKey)
        } catch {
            print("Failed to encode favorites: \(error.localizedDescription)")
        }
    }
}

