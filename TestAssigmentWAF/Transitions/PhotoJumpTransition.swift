//
//  PhotoJumpTransition.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 17/09/2024.
//

import UIKit

class PhotoJumpTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var isPresenting = true

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4 // Duration of the animation
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to),
              let fromView = transitionContext.view(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView
        let initialTransform = CGAffineTransform(translationX: -containerView.frame.width, y: 0)
        
        if isPresenting {
            toView.transform = initialTransform
            containerView.addSubview(toView)

            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
                toView.transform = .identity
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromView.transform = initialTransform
            }, completion: { _ in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        }
    }
}
