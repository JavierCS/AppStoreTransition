//
//  CardCollectionViewCell.swift
//  AppStoreTransition
//
//  Created by Javier Cruz Santiago on 12/06/20.
//  Copyright © 2020 JCS Development. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    static let nib: UINib = UINib(nibName: "CardCollectionViewCell", bundle: Bundle.main)
    static let id: String = "CardCollectionViewCellId"
    
    @IBOutlet weak var cardContentView: CardContentView!
    
    private var disabledHighlightedAnimation = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cardContentView.layer.cornerRadius = 16
        self.cardContentView.layer.masksToBounds = true
        
        self.backgroundColor = .clear
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5
    }
    
    func resetTransform() {
        self.transform = CGAffineTransform.identity
    }
    
    func freezeAnimations() {
        self.disabledHighlightedAnimation = true
        self.layer.removeAllAnimations()
    }
    
    func unfreezeAnimations() {
        self.disabledHighlightedAnimation = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.animate(isHighlighted: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.animate(isHighlighted: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.animate(isHighlighted: false)
    }
    
    func animate(isHighlighted: Bool, completion: ((Bool) -> ())? = nil) {
        let animationOptions: AnimationOptions = [.allowUserInteraction]
        
        if self.disabledHighlightedAnimation { return }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: animationOptions,
                       animations: {
                        if isHighlighted {
                            self.transform = CGAffineTransform(scaleX: 0.8,
                            y: 0.96)
                        } else {
                            self.resetTransform()
                        }
                        
        }, completion: completion)
    }
}
