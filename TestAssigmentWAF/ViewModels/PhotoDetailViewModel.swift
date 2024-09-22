//
//  PhotoDetailViewModel.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 22/09/2024.
//

import Foundation

class PhotoDetailViewModel {
    
    // MARK: - Properties
    private var photo: Photo
    
    var authorText: String {
        "Author: \(photo.authorName)"
    }
    
    var dateText: String {
        if let formattedDate = DateFormatterHelper.formattedDate(from: photo.creationDate) {
            return "Created: \(formattedDate)"
        } else {
            return "Created: Unknown"
        }
    }
    
    var locationText: String {
        "Location: \(photo.location ?? "Unknown")"
    }
    
    var downloadsText: String {
        "Downloads: \(photo.downloads)"
    }
    
    var imageUrl: String {
        return photo.imageUrl
    }
    
    var isFavorite: Bool {
        return photo.isFavorite
    }
    
    // Callback to update the favorite status UI in the view controller
    var onFavoriteStatusChanged: ((Bool) -> Void)?
    
    // MARK: - Initialization
    init(photo: Photo) {
        self.photo = photo
    }
    
    // MARK: - Methods
    
    // Toggle favorite status and update persistence
    func toggleFavorite() {
        photo.isFavorite.toggle()
        
        if photo.isFavorite {
            PersistenceManager.shared.addFavorite(photo)
        } else {
            PersistenceManager.shared.removeFavorite(photo)
        }
        
        onFavoriteStatusChanged?(photo.isFavorite)
        NotificationCenter.default.post(name: .favoriteStatusChanged, object: photo)
    }
}
