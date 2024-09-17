//
//  NavigationControllerDelegate.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 17/09/2024.
//

import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    let transition = SlideInTransition()
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard operation == .push || operation == .pop else { return nil }
        transition.isPresenting = (operation == .push)
        return transition
    }
}
