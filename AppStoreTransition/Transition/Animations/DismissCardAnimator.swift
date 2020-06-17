//
//  DismissCardAnimator.swift
//  AppStoreTransition
//
//  Created by Javier Cruz Santiago on 16/06/20.
//  Copyright © 2020 JCS Development. All rights reserved.
//

import UIKit

class DismissCardAnimator: NSObject {
    struct Params {
        let fromCardframe: CGRect
        let fromCardFrameWithoutTransform: CGRect
        let fromCell: CardCollectionViewCell
    }
    
    struct Constants {
        static let relativeDurationBeforeNonInteractive: TimeInterval = 0.5
        static let minimumScaleBeforeNonInteractive: CGFloat = 0.8
    }
    
    private let params: Params
    
    init(params: Params) {
        self.params = params
        super.init()
    }
}

extension DismissCardAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return GlobalConstants.dismissalAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let ctx = transitionContext
        let container = ctx.containerView
        let screens: (cardDetail: CardDetailViewController, home: HomeViewController) = (
            ctx.viewController(forKey: .from)! as! CardDetailViewController,
            ctx.viewController(forKey: .to)! as! HomeViewController
        )
        
        let cardDetailView = ctx.view(forKey: .from)!
        
        let animatedContainerView = UIView()
        if GlobalConstants.isEnabledDebugAnimatingViews {
            animatedContainerView.layer.borderColor = UIColor.yellow.cgColor
            animatedContainerView.layer.borderWidth = 5
            cardDetailView.layer.borderColor = UIColor.red.cgColor
            cardDetailView.layer.borderWidth = 5
        }
        
        animatedContainerView.translatesAutoresizingMaskIntoConstraints = false
        cardDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        container.removeConstraints(container.constraints)
        
        container.addSubview(animatedContainerView)
        animatedContainerView.addSubview(cardDetailView)
        
        cardDetailView.edges(to: cardDetailView)
        
        animatedContainerView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        let animatedContainerTopConstraint = animatedContainerView.topAnchor.constraint(equalTo: container.topAnchor)
        let animatedContainerWidthConstraint = animatedContainerView.widthAnchor.constraint(equalToConstant: cardDetailView.frame.width)
        let animatedContainerHeightConstraint = animatedContainerView.heightAnchor.constraint(equalToConstant: cardDetailView.frame.height)
        
        NSLayoutConstraint.activate([animatedContainerTopConstraint, animatedContainerWidthConstraint, animatedContainerHeightConstraint])
        
        let topTemporaryFix = screens.cardDetail.cardContentView.topAnchor.constraint(equalTo: cardDetailView.topAnchor)
        topTemporaryFix.isActive = GlobalConstants.isEnabledWeirdTopInsetsFix
        
        container.layoutIfNeeded()
        
        let strechCardToFillBottom = screens.cardDetail.cardContentView.bottomAnchor.constraint(equalTo: cardDetailView.bottomAnchor)
        
        func animateCardViewBackToPlace() {
            strechCardToFillBottom.isActive = true
//            screens.cardDetail.
            cardDetailView.transform = .identity
            animatedContainerTopConstraint.constant = self.params.fromCardFrameWithoutTransform.minY
            animatedContainerWidthConstraint.constant = self.params.fromCardFrameWithoutTransform.width
            animatedContainerHeightConstraint.constant = self.params.fromCardFrameWithoutTransform.height
            container.layoutIfNeeded()
        }
        
        func completeEverything() {
            let success = !ctx.transitionWasCancelled
            animatedContainerView.removeConstraints(animatedContainerView.constraints)
            animatedContainerView.removeFromSuperview()
            if success {
                cardDetailView.removeFromSuperview()
                self.params.fromCell.isHidden = false
            } else {
                screens.cardDetail.isFontStateHighlighted = true
                
                topTemporaryFix.isActive = false
                strechCardToFillBottom.isActive = false
                
                cardDetailView.removeConstraint(topTemporaryFix)
                cardDetailView.removeConstraint(strechCardToFillBottom)
                
                container.removeConstraints(container.constraints)
                
                container.addSubview(cardDetailView)
                cardDetailView.edges(to: container)
            }
            ctx.completeTransition(success)
        }
        
        UIView.animate(withDuration: transitionDuration(using: ctx),
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.0,
                       options: [],
                       animations: {
            animateCardViewBackToPlace()
        }) { (finished) in
            completeEverything()
        }
        
        UIView.animate(withDuration: transitionDuration(using: ctx) * 0.6) {
            screens.cardDetail.scrollView.contentOffset = .zero
        }
    }
    
    
}
