//
//  PhotoDetailViewController.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 14/09/2024.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    private let photo: Photo
    private var isFavorite: Bool = false
    
    private let imageView = UIImageView()
    private let authorLabel = UILabel()
    private let dateLabel = UILabel()
    private let locationLabel = UILabel()
    private let downloadsLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    
    init(photo: Photo) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo Details"
        view.backgroundColor = .white
        
        setupViews()
        configure(with: photo)
    }
    
    private func setupViews() {
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        downloadsLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        favoriteButton.setTitle("Add to Favorites", for: .normal)
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [authorLabel, dateLabel, locationLabel, downloadsLabel, favoriteButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configure(with photo: Photo) {
        imageView.loadImage(from: photo.imageUrl)
        authorLabel.text = "Author: \(photo.authorName)"
        dateLabel.text = "Created: \(photo.creationDate)"
        locationLabel.text = "Location: \(photo.location ?? "Unknown")"
        downloadsLabel.text = "Downloads: \(photo.downloads)"
        
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        let title = isFavorite ? "Remove from Favorites" : "Add to Favorites"
        favoriteButton.setTitle(title, for: .normal)
    }
    
    @objc private func toggleFavorite() {
        isFavorite.toggle()
        if isFavorite {
            PersistenceManager.shared.addFavorite(photo)
        } else {
            PersistenceManager.shared.removeFavorite(photo)
        }
        updateFavoriteButton()
    }
}
