//
//  ViewController.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 13/09/2024.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        let photosVC = PhotosViewController()
        photosVC.tabBarItem = UITabBarItem(title: "Photos", image: UIImage(systemName: "photo"), tag: 0)
        
        let favoritesVC = FavoritesViewController()
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), tag: 1)
        
        viewControllers = [UINavigationController(rootViewController: photosVC), UINavigationController(rootViewController: favoritesVC)]
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Pop to root view controller to ensure stack reset
        if let navController = viewController as? UINavigationController {
            navController.popToRootViewController(animated: false)
        }
    }
}
