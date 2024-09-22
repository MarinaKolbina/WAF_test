//
//  FavoritesViewController.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 14/09/2024.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(FavoritePhotoCell.self, forCellReuseIdentifier: FavoritePhotoCell.identifier)
        tableView.backgroundColor = .systemBackground
        tableView.separatorColor = .separator
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "No favorites yet"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let viewModel = FavoritesViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        title = "Favorites"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Initially, hide the tableView if no favorites
        tableView.isHidden = viewModel.numberOfFavorites() == 0
        placeholderLabel.isHidden = viewModel.numberOfFavorites() != 0
    }
    
    // MARK: - Bindings
    
    private func setupBindings() {
        viewModel.onFavoritesUpdated = { [weak self] in
            guard let self = self else { return }
            
            let hasFavorites = self.viewModel.numberOfFavorites() > 0
            
            // Toggle visibility of tableView and placeholderLabel
            self.tableView.isHidden = !hasFavorites
            self.placeholderLabel.isHidden = hasFavorites
            
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfFavorites()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritePhotoCell.identifier, for: indexPath) as? FavoritePhotoCell else {
            return UITableViewCell()
        }
        
        let favoritePhoto = viewModel.favoritePhoto(at: indexPath.row)
        cell.configure(with: favoritePhoto)
        cell.backgroundColor = .secondarySystemBackground
        cell.textLabel?.textColor = .label
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPhoto = viewModel.favoritePhoto(at: indexPath.row)
        let detailVC = PhotoDetailViewController(photo: selectedPhoto)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
