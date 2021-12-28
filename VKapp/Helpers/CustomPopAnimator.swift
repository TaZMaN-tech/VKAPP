//
//  CustomPopAnimator.swift
//  VKapp
//
//  Created by Тадевос Курдоглян on 28.12.2021.
//

import UIKit

final class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to)
            else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        
        destination.view.frame = source.view.frame
        destination.view.transform = CGAffineTransform.identity
            .concatenating(CGAffineTransform(translationX: (-destination.view.frame.height+destination.view.frame.width)/2, y: 0))
            .concatenating(CGAffineTransform(rotationAngle: CGFloat.pi/2))
            
        
        UIView.animateKeyframes(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: [],
            animations: {
                
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 1,
                    animations: {
                        source.view.transform = CGAffineTransform.identity
                            .concatenating(CGAffineTransform(rotationAngle: -CGFloat.pi/2))
                            .concatenating(CGAffineTransform(translationX: (source.view.frame.height+source.view.frame.width)/2, y: 0))
                        destination.view.transform = CGAffineTransform.identity
                    }
                )
            },
            completion: { finished in
                let finishedAndNotCancelled = finished && !transitionContext.transitionWasCancelled
                
                if finishedAndNotCancelled {
                    source.removeFromParent()
                } else if transitionContext.transitionWasCancelled {
                    destination.view.transform = .identity
                }
                transitionContext.completeTransition(finishedAndNotCancelled)
            }
        )
    }
    
}
