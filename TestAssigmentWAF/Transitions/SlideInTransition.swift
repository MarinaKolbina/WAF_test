//
//  SlideInTransition.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 17/09/2024.
//

import UIKit

class SlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var isPresenting = true
    var fromLeft = true

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3 // Duration of the animation
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }
        guard let fromView = transitionContext.view(forKey: .from) else { return }

        let containerView = transitionContext.containerView
        let offScreenLeft = CGAffineTransform(translationX: -containerView.frame.width, y: 0)
        let offScreenRight = CGAffineTransform(translationX: containerView.frame.width, y: 0)

        if isPresenting {
            toView.transform = fromLeft ? offScreenLeft : offScreenRight
            containerView.addSubview(toView)

            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toView.transform = .identity
                fromView.transform = self.fromLeft ? offScreenRight : offScreenLeft
            }) { _ in
                fromView.transform = .identity
                transitionContext.completeTransition(true)
            }
        } else {
            containerView.insertSubview(toView, belowSubview: fromView)
            fromView.transform = .identity

            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromView.transform = self.fromLeft ? offScreenLeft : offScreenRight
            }) { _ in
                transitionContext.completeTransition(true)
            }
        }
    }
}

