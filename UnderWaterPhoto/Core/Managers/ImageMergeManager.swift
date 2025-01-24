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
	
	func mergeWatermark(image: UIImage) -> UIImage {
		let size = image.size
		UIGraphicsBeginImageContext(size)
		
		guard let watermark = UIImage(named: "watermark") else { return UIImage() }
		let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		image.draw(in: areaSize)
		let coef = size.width / 343
		let watermarkAreaSize = CGRect(x: 32 * coef, y: size.height - (32 * coef + watermark.size.height * coef), width: watermark.size.width * coef, height: watermark.size.height * coef)
		watermark.draw(in: watermarkAreaSize, blendMode: .normal, alpha: 1)
		
		let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		
		return newImage
	}
}
