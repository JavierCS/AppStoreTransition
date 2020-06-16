//
//  CardContentViewModel.swift
//  AppStoreTransition
//
//  Created by Javier Cruz Santiago on 16/06/20.
//  Copyright © 2020 JCS Development. All rights reserved.
//

import UIKit

struct CardContentViewModel {
    var title: String
    var description: String
    var date: String
    var image: UIImage
    
    func highlightedImage() -> CardContentViewModel {
        let scaledImage = image.resize(toWidth: image.size.width * 0.96)
        return CardContentViewModel(title: self.title,
                                    description: self.description,
                                    date: "11-04-2020",
                                    image: scaledImage)
    }
}
