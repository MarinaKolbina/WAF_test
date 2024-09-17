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
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to),
              let fromView = transitionContext.view(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView
        let offScreenLeft = CGAffineTransform(translationX: -containerView.frame.width, y: 0)
        let offScreenRight = CGAffineTransform(translationX: containerView.frame.width, y: 0)

        if isPresenting {
            toView.transform = fromLeft ? offScreenLeft : offScreenRight
            containerView.addSubview(toView)

            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toView.transform = .identity
                fromView.transform = self.fromLeft ? offScreenRight : offScreenLeft
            }) { finished in
                fromView.transform = .identity
                transitionContext.completeTransition(finished)
            }
        } else {
            containerView.insertSubview(toView, belowSubview: fromView)
            toView.transform = .identity

            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromView.transform = self.fromLeft ? offScreenLeft : offScreenRight
            }) { finished in
                fromView.transform = .identity
                transitionContext.completeTransition(finished)
            }
        }
    }
}

