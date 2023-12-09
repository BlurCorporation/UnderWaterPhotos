//
//  ImageMergeManager.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 07.12.2023.
//

import Foundation

class ImageMergeManager {
    func mergeImages(bottomImage: UIImage, topImage: UIImage) -> UIImage {
        let bottomImage = bottomImage
        let topImage = topImage

        let size = bottomImage.size
        UIGraphicsBeginImageContext(size)

        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        bottomImage.draw(in: areaSize)

        topImage.draw(in: areaSize, blendMode: .normal, alpha: 1)

        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
