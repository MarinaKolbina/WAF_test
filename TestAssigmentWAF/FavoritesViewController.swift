//
//  FavoritesViewController.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 14/09/2024.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var tableView: UITableView!
    private var favoritePhotos: [Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = .white
        
        setupTableView()
        loadFavorites()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(FavoritePhotoCell.self, forCellReuseIdentifier: FavoritePhotoCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
    }
    
    private func loadFavorites() {
        favoritePhotos = PersistenceManager.shared.getFavorites()
        tableView.reloadData()
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
        let photoDetailVC = PhotoDetailViewController(photo: favoritePhotos[indexPath.row])
        navigationController?.pushViewController(photoDetailVC, animated: true)
    }
}
