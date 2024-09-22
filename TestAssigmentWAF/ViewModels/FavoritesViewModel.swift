//
//  FavoritesViewModel.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 22/09/2024.
//

import Foundation

class FavoritesViewModel {
    
    // MARK: - Properties
    private(set) var favoritePhotos: [Photo] = [] {
        didSet {
            onFavoritesUpdated?()
        }
    }
    
    var onFavoritesUpdated: (() -> Void)?
    
    // MARK: - Initialization
    init() {
        loadFavorites()
        setupObservers()
    }
    
    // MARK: - Public Methods
    
    func numberOfFavorites() -> Int {
        return favoritePhotos.count
    }
    
    func favoritePhoto(at index: Int) -> Photo {
        return favoritePhotos[index]
    }
    
    // MARK: - Private Methods
    
    private func loadFavorites() {
        favoritePhotos = PersistenceManager.shared.getFavorites()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoriteStatusChanged), name: .favoriteStatusChanged, object: nil)
    }
    
    // MARK: - Notification Handling
    
    @objc private func handleFavoriteStatusChanged(notification: Notification) {
        loadFavorites()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .favoriteStatusChanged, object: nil)
    }
}
