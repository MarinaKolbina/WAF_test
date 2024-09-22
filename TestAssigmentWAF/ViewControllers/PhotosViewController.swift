//
//  PhotosViewController.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 14/09/2024.
//

import UIKit

class PhotosViewController: UIViewController {
    
    private enum Constants {
        static let itemSpacing: CGFloat = 9
        static let numberOfItemsPerRow: CGFloat = 2
        static let title = "Photos"
    }
    
    // MARK: - UI Elements
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Photos"
        searchBar.delegate = self
        searchBar.barTintColor = .systemBackground
        searchBar.searchTextField.textColor = .label
        searchBar.searchTextField.backgroundColor = .secondarySystemBackground
        return searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    private let viewModel = PhotosViewModel()
    private let navigationControllerDelegate = NavigationControllerDelegate()
    private var searchDebounceTimer: Timer?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupNotifications()
        viewModel.fetchPhotos()
        
        // Adding tap gesture recognizer to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        title = Constants.title
        view.backgroundColor = .systemBackground
        navigationItem.titleView = searchBar
        view.addSubview(collectionView)
        navigationController?.delegate = navigationControllerDelegate
    }
    
    private func setupBindings() {
        viewModel.onPhotosUpdated = { [weak self] in
            self?.collectionView.reloadData()
            
            // Adjust the content size to force scrolling
            DispatchQueue.main.async {
                self?.adjustScrollViewContentInset()
            }
        }
        
        viewModel.onErrorOccurred = { [weak self] errorMessage in
            self?.showAlert(with: "Error", message: errorMessage)
        }
    }
    
    private func adjustScrollViewContentInset() {
        collectionView.layoutIfNeeded()
        
        let contentHeight = collectionView.contentSize.height
        let frameHeight = collectionView.frame.height
        
        // If content height is less than the frame height, add inset to allow scrolling
        if contentHeight < frameHeight {
            let inset = frameHeight - contentHeight + 1
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
        } else {
            // Reset the content inset when content is large enough to naturally scroll
            collectionView.contentInset = .zero
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoriteStatusChanged), name: .favoriteStatusChanged, object: nil)
    }
    
    // MARK: - Helper Methods
    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing = Constants.itemSpacing
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        
        let totalSpacing = (Constants.numberOfItemsPerRow + 1) * spacing
        let itemWidth = (view.frame.width - totalSpacing) / Constants.numberOfItemsPerRow
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        return layout
    }
    
    private func showAlert(with title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func handleFavoriteStatusChanged(notification: Notification) {
        guard let updatedPhoto = notification.object as? Photo else { return }
        viewModel.handleFavoriteStatusChanged(photo: updatedPhoto)
    }
    
    // MARK: - Dismiss Keyboard
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UICollectionViewDataSource

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel.photos[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhoto = viewModel.photos[indexPath.item]
        
        if let layoutAttributes = collectionView.layoutAttributesForItem(at: indexPath) {
            let tapLocation = layoutAttributes.frame.origin.x
            navigationControllerDelegate.transition.fromLeft = (tapLocation < collectionView.frame.width / 2)
        }
        
        if let navigationController = navigationController {
            navigationController.pushViewController(PhotoDetailViewController(photo: selectedPhoto), animated: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            resetContentInsetAndReadjust()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        resetContentInsetAndReadjust()
    }
    
    private func resetContentInsetAndReadjust() {
        let contentHeight = collectionView.contentSize.height
        let frameHeight = collectionView.frame.height
        
        if contentHeight < frameHeight {
            UIView.animate(withDuration: 0.5) {
                self.collectionView.contentInset = .zero
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.adjustScrollViewContentInset()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height * 2 {
            // Ensure the view model isn't already fetching more data
            if viewModel.canFetchMore() {
                print("Fetching more photos...") // Debugging output
                viewModel.fetchPhotos(query: viewModel.currentQuery)
            }
        }
    }
}

// MARK: - UISearchBarDelegate

extension PhotosViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        searchBar.resignFirstResponder()
        viewModel.fetchPhotos(query: query)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        searchDebounceTimer?.invalidate()
        
        // Start a new timer to delay the search
        searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.fetchPhotos(query: searchText)  // Perform the search after delay
        }
    }
}

