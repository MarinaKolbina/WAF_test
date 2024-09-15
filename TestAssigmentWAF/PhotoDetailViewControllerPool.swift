//
//  PhotoDetailViewControllerPool.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 15/09/2024.
//

import UIKit

class PhotoDetailViewControllerPool {
    static let shared = PhotoDetailViewControllerPool()
    private var controllers: [String: PhotoDetailViewController] = [:]
    
    private init() {}

    func getViewController(for photo: Photo) -> PhotoDetailViewController {
        if let existingVC = controllers[photo.id] {
            return existingVC
        } else {
            let newVC = PhotoDetailViewController(photo: photo)
            controllers[photo.id] = newVC
            return newVC
        }
    }
    
    func removeViewController(for photo: Photo) {
        controllers[photo.id] = nil
    }
}
