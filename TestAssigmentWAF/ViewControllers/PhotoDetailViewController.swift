//
//  PhotoDetailViewController.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 14/09/2024.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    // MARK: - Properties
    private var viewModel: PhotoDetailViewModel
    
    // MARK: - UI Elements
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var downloadsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    init(photo: Photo) {
        self.viewModel = PhotoDetailViewModel(photo: photo)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo Details"
        view.backgroundColor = .systemBackground
        
        setupViews()
        bindViewModel()
    }
    
    private func setupViews() {
        view.addSubview(imageView)
        
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
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        imageView.loadImage(from: viewModel.imageUrl, placeholder: UIImage(named: "placeholder")) { success in
            if !success {
                print("Failed to load image.") // placeholder was set
            }
        }
        
        authorLabel.text = viewModel.authorText
        dateLabel.text = viewModel.dateText
        locationLabel.text = viewModel.locationText
        downloadsLabel.text = viewModel.downloadsText
        updateFavoriteButton()
        
        // Observe favorite status changes
        viewModel.onFavoriteStatusChanged = { [weak self] isFavorite in
            self?.updateFavoriteButton()
        }
    }
    
    private func updateFavoriteButton() {
        let title = viewModel.isFavorite ? "Remove from Favorites" : "Add to Favorites"
        favoriteButton.setTitle(title, for: .normal)
    }
    
    @objc private func toggleFavorite() {
        viewModel.toggleFavorite()
    }
}

