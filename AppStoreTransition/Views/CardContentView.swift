//
//  CardContentView.swift
//  AppStoreTransition
//
//  Created by Javier Cruz Santiago on 12/06/20.
//  Copyright © 2020 JCS Development. All rights reserved.
//

import UIKit

@IBDesignable class CardContentView: UIView, NibLoadable {
    @IBOutlet weak var imvImage: UIImageView!
    @IBOutlet weak var vevBlur: UIVisualEffectView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    var cardViewModel: CardContentViewModel! {
        didSet {
            self.imvImage.image = self.cardViewModel.image
            self.lblTitle.text = self.cardViewModel.title
            self.lblDescription.text = self.cardViewModel.description
            self.lblDate.text = self.cardViewModel.date
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.fromNib()
        self.commonSetup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.fromNib()
        self.commonSetup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonSetup()
    }

    private func commonSetup() {
        // *Make the background image stays still at the center while we animationg,
        // else the image will get resized during animation.
        self.imvImage.contentMode = .center
    }
}
