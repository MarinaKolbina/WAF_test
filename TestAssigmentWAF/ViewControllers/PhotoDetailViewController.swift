//
//  PhotoDetailViewController.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 14/09/2024.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    var photo: Photo
    
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
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        downloadsLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        favoriteButton.setTitle(photo.isFavorite ? "Remove from Favorites" : "Add to Favorites", for: .normal)
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
    
    private func formattedDate(from dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "d MMMM yyyy"
            outputFormatter.locale = Locale.current
            
            return outputFormatter.string(from: date)
        } else {
            return nil
        }
    }
    
    private func configure(with photo: Photo) {
        imageView.loadImage(from: photo.imageUrl, placeholder: UIImage(named: "placeholder"))
        authorLabel.text = "Author: \(photo.authorName)"
        
        if let formattedDate = formattedDate(from: photo.creationDate) {
            dateLabel.text = "Created: \(formattedDate)"
        } else {
            dateLabel.text = "Created: Unknown"
        }
        
        locationLabel.text = "Location: \(photo.location ?? "Unknown")"
        downloadsLabel.text = "Downloads: \(photo.downloads)"
        
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        let title = photo.isFavorite ? "Remove from Favorites" : "Add to Favorites"
        favoriteButton.setTitle(title, for: .normal)
    }
    
    @objc private func toggleFavorite() {
        photo.isFavorite.toggle()
        if photo.isFavorite {
            PersistenceManager.shared.addFavorite(photo)
        } else {
            PersistenceManager.shared.removeFavorite(photo)
        }
        updateFavoriteButton()
        
        // Post notification when favorite status changes
        NotificationCenter.default.post(name: .favoriteStatusChanged, object: photo)
    }
}

extension Notification.Name {
    static let favoriteStatusChanged = Notification.Name("favoriteStatusChanged")
}
