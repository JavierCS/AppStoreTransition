//
//  UIImageExtensions.swift
//  AppStoreTransition
//
//  Created by Javier Cruz Santiago on 16/06/20.
//  Copyright © 2020 JCS Development. All rights reserved.
//

import UIKit

extension UIImage {
    func resize(toWidth scaledToWidth: CGFloat) -> UIImage {
        let image = self
        let oldWidth = image.size.width
        let scaleFactor = scaledToWidth / oldWidth
        
        let newHeight = image.size.height * scaleFactor
        let newWidth = image.size.width * scaleFactor
        
        let scaledSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContextWithOptions(scaledSize, true, image.scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}
