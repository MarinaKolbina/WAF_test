//
//  PhotosViewController.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 14/09/2024.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    private var collectionView: UICollectionView!
    private var photos: [Photo] = []
    private var filteredPhotos: [Photo] = []
    private var searchBar: UISearchBar!
    private let navigationControllerDelegate = NavigationControllerDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photos"
        view.backgroundColor = .white
        
        setupSearchBar()
        setupCollectionView()
        fetchPhotos()
        navigationController?.delegate = navigationControllerDelegate
    }
    
    private func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search Photos"
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 9
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        
        let numberOfItemsPerRow: CGFloat = 2
        let totalSpacing = (numberOfItemsPerRow + 1) * spacing
        let itemWidth = (view.frame.width - totalSpacing) / numberOfItemsPerRow
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
    }
    
    private func fetchPhotos(query: String = "") {
        UnsplashAPI.fetchPhotos(query: query) { [weak self] photos in
            let favoritePhotos = PersistenceManager.shared.getFavorites()
            let favoritePhotoIDs = Set(favoritePhotos.map { $0.id }) // Use Set for faster lookups
            
            let updatedPhotos = photos.map { photo -> Photo in
                var updatedPhoto = photo
                updatedPhoto.isFavorite = favoritePhotoIDs.contains(photo.id)
                return updatedPhoto
            }
    
            DispatchQueue.main.async {
                self?.photos = updatedPhotos
                self?.filteredPhotos = updatedPhotos
                self?.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.configure(with: filteredPhotos[indexPath.item])
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhoto = filteredPhotos[indexPath.item]
        
        // Determine tap location
        let tapLocation = collectionView.layoutAttributesForItem(at: indexPath)!.frame.origin.x
        navigationControllerDelegate.transition.fromLeft = (tapLocation < collectionView.frame.width / 2)
        
        let photoDetailVC = PhotoDetailViewControllerPool.shared.getViewController(for: selectedPhoto)
        
        if let existingVC = navigationController?.viewControllers.first(where: { $0 === photoDetailVC }) {
            navigationController?.popToViewController(existingVC, animated: true)
        } else {
            navigationController?.pushViewController(photoDetailVC, animated: true)
        }
    }

    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else {
            filteredPhotos = photos
            collectionView.reloadData()
            return
        }
        
        filteredPhotos = photos.filter { photo in
            photo.authorName.lowercased().contains(query.lowercased())
        }
        
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredPhotos = photos
        collectionView.reloadData()
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
