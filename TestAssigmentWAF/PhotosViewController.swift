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
    private var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photos"
        view.backgroundColor = .white
        
        setupSearchBar()
        setupCollectionView()
        
        fetchPhotos() // Initial fetch
    }
    
    private func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search Photos"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width / 2 - 16, height: view.frame.width / 2 - 16)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
    }
    
    private func fetchPhotos(query: String = "") {
        // Networking code to fetch photos from Unsplash API
        UnsplashAPI.fetchPhotos(query: query) { [weak self] photos in
            DispatchQueue.main.async {
                self?.photos = photos
                self?.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.configure(with: photos[indexPath.item])
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhoto = photos[indexPath.item]
        
        let photoDetailVC = PhotoDetailViewControllerPool.shared.getViewController(for: selectedPhoto)
        
        if let existingVC = navigationController?.viewControllers.first(where: { $0 === photoDetailVC }) {
            navigationController?.popToViewController(existingVC, animated: true)
        } else {
            navigationController?.pushViewController(photoDetailVC, animated: true)
        }
    }

    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        fetchPhotos(query: query)
    }
}

extension UIViewController {
    func findPhotoDetailViewController(for photo: Photo) -> PhotoDetailViewController? {
        guard let navigationController = self.navigationController else { return nil }
        
        for controller in navigationController.viewControllers {
            if let photoDetailVC = controller as? PhotoDetailViewController,
               photoDetailVC.photo.id == photo.id {
                return photoDetailVC
            }
        }
        return nil
    }
}

