//
//  PresentCardTransitionDriver.swift
//  AppStoreTransition
//
//  Created by Javier Cruz Santiago on 16/06/20.
//  Copyright © 2020 JCS Development. All rights reserved.
//

import UIKit

class PresentCardTransitionDriver {
    let animator: UIViewPropertyAnimator
    
    init(params: PresentCardAnimator.Params, transitionContext: UIViewControllerContextTransitioning, baseAnimator: UIViewPropertyAnimator) {
        let ctx = transitionContext
        let container = ctx.containerView
        let screens: (home: HomeViewController, cardDetail: CardDetailViewController) = (
            ctx.viewController(forKey: .from)! as! HomeViewController,
            ctx.viewController(forKey: .to)! as! CardDetailViewController
        )
        let cardDetailView = ctx.view(forKey: .to)!
        cardDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        let fromCardFrame = params.fromCardFrame
        
        let animatedContainerView = UIView()
        animatedContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        //DEBUG
        animatedContainerView.layer.borderColor = UIColor.cyan.cgColor
        animatedContainerView.layer.borderWidth = 5
        cardDetailView.layer.borderColor = UIColor.yellow.cgColor
        cardDetailView.layer.borderWidth = 5
        
        container.addSubview(animatedContainerView)
        
        let animatedContainerConstraints = [
            animatedContainerView.widthAnchor.constraint(equalToConstant: container.bounds.width),
            animatedContainerView.heightAnchor.constraint(equalToConstant: container.bounds.height),
            animatedContainerView.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(animatedContainerConstraints)
        
        let animatedContainerVerticalConstraint = animatedContainerView.centerYAnchor.constraint(
            equalTo: container.centerYAnchor,
            constant: (fromCardFrame.height/2 + fromCardFrame.minY) - container.bounds.height/2
        )
        
        animatedContainerVerticalConstraint.isActive = true
        
        animatedContainerView.addSubview(cardDetailView)
        
        cardDetailView.centerYAnchor.constraint(equalTo: animatedContainerView.centerYAnchor).isActive = true
        cardDetailView.centerXAnchor.constraint(equalTo: animatedContainerView.centerXAnchor).isActive = true
        
        let cardWidthConstraint = cardDetailView.widthAnchor.constraint(equalToConstant: fromCardFrame.width)
        let cardHeightConstraint = cardDetailView.heightAnchor.constraint(equalToConstant: fromCardFrame.height)
        NSLayoutConstraint.activate([cardWidthConstraint, cardHeightConstraint])
        
        cardDetailView.layer.cornerRadius = 16
        
        // -------------------------------
        // Final preparation
        // -------------------------------
        params.fromCell.isHidden = true
        params.fromCell.resetTransform()
        
        let topTemporaryFix = screens.cardDetail.cardContentView.topAnchor.constraint(equalTo: cardDetailView.topAnchor)
        topTemporaryFix.isActive = true
        
        container.layoutIfNeeded()
        
        // ------------------------------
        // 1. Animate container bouncing up
        // ------------------------------
        func animateContainerBouncingUp() {
            animatedContainerVerticalConstraint.constant = 0
            container.layoutIfNeeded()
        }
        
        // ------------------------------
        // 2. Animate cardDetail filling up the container
        // ------------------------------
        func animateCardDetailViewSizing() {
            cardWidthConstraint.constant = animatedContainerView.bounds.width
            cardHeightConstraint.constant = animatedContainerView.bounds.height
            cardDetailView.layer.cornerRadius = 0
            container.layoutIfNeeded()
        }
        
        func completeEverything() {
            //Remove temporary
            animatedContainerView.removeConstraints(animatedContainerView.constraints)
            animatedContainerView.removeFromSuperview()
            
            //Re add to the top
            container.addSubview(cardDetailView)
            
            cardDetailView.removeConstraints([topTemporaryFix, cardWidthConstraint, cardHeightConstraint])
            
            cardDetailView.edges(to: container, top: -1)
            
            screens.cardDetail.scrollView.isScrollEnabled = true
            
            let success = !ctx.transitionWasCancelled
            ctx.completeTransition(success)
        }
        
        baseAnimator.addAnimations {
            animateContainerBouncingUp()
            
            let cardExpanding = UIViewPropertyAnimator(duration: baseAnimator.duration * 0.6, curve: .linear) {
                animateCardDetailViewSizing()
            }
            cardExpanding.startAnimation()
        }
        
        baseAnimator.addCompletion { (_) in
            completeEverything()
        }
        
        self.animator = baseAnimator
    }
}
