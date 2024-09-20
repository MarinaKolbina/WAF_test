//
//  FavoritesViewController.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 14/09/2024.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var tableView: UITableView!
    
    // The source of truth - this will load data from the PersistenceManager
    private var favoritePhotos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = .white
        
        setupTableView()
        loadFavorites()
        
        // Listen to changes in the favorite status
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoriteStatusChanged), name: .favoriteStatusChanged, object: nil)
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(FavoritePhotoCell.self, forCellReuseIdentifier: FavoritePhotoCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    // Fetch the favorite photos from PersistenceManager
    private func loadFavorites() {
        favoritePhotos = PersistenceManager.shared.getFavorites()
        tableView.reloadData()
    }

    // MARK: - Notification Handler
    @objc private func handleFavoriteStatusChanged(notification: Notification) {
        loadFavorites()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePhotos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritePhotoCell.identifier, for: indexPath) as! FavoritePhotoCell
        cell.configure(with: favoritePhotos[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPhoto = favoritePhotos[indexPath.row]
        navigationController?.pushViewController(PhotoDetailViewController(photo: selectedPhoto), animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .favoriteStatusChanged, object: nil)
    }
}
