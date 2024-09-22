//
//  PhotosViewModel.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 22/09/2024.
//

import Foundation

class PhotosViewModel {
    
    // MARK: - Properties
    
    private(set) var photos: [Photo] = [] {
        didSet {
            self.onPhotosUpdated?()
        }
    }
    
    var onPhotosUpdated: (() -> Void)?
    var onErrorOccurred: ((String) -> Void)?
    
    private var isFetchingMore = false
    private var fetchingWithQuery: Bool = false
    private(set) var currentQuery: String = ""
    
    // MARK: - Public Methods
    
    // Check if more photos can be fetched
    func canFetchMore() -> Bool {
        return !isFetchingMore
    }
    
    func fetchPhotos(query: String = "", count: Int = 10) {
        guard !isFetchingMore else { return }
        isFetchingMore = true
        
        UnsplashAPI.fetchPhotos(query: query, count: count) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let fetchedPhotos):
                self.processFetchedPhotos(fetchedPhotos, for: query)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchingMore = false
                    
                    // If it's an APIError, use the custom message
                    if let apiError = error as? APIError {
                        switch apiError {
                        case .forbidden(let message):
                            self.onErrorOccurred?("Forbidden: \(message)")
                        case .custom(let message):
                            self.onErrorOccurred?(message)
                        case .decodingError(let message):
                            self.onErrorOccurred?("Decoding Error: \(message)")
                        }
                    } else {
                        self.onErrorOccurred?(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func handleFavoriteStatusChanged(photo: Photo) {
        if let index = photos.firstIndex(where: { $0.id == photo.id }) {
            photos[index].isFavorite = photo.isFavorite
        }
    }
    
    // MARK: - Private Methods
    
    private func processFetchedPhotos(_ fetchedPhotos: [Photo], for query: String) {
        let updatedPhotos = self.updatePhotosWithFavorites(fetchedPhotos)
        
        DispatchQueue.main.async {
            let existingPhotoIDs = Set(self.photos.map { $0.id })
            let nonDuplicatePhotos = updatedPhotos.filter { !existingPhotoIDs.contains($0.id) }
            
            if query.isEmpty {
                self.photos = self.fetchingWithQuery ? nonDuplicatePhotos : self.photos + nonDuplicatePhotos
                self.fetchingWithQuery = false
            } else {
                self.photos = (self.fetchingWithQuery && query == self.currentQuery) ? self.photos + nonDuplicatePhotos : nonDuplicatePhotos
                self.currentQuery = query
                self.fetchingWithQuery = true
            }
            
            self.isFetchingMore = false
        }
    }
    
    private func updatePhotosWithFavorites(_ photos: [Photo]) -> [Photo] {
        let favoritePhotoIDs = Set(PersistenceManager.shared.getFavorites().map { $0.id })
        return photos.map { photo in
            var updatedPhoto = photo
            updatedPhoto.isFavorite = favoritePhotoIDs.contains(photo.id)
            return updatedPhoto
        }
    }
}
