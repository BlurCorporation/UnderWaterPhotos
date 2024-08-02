//
//  UIImage+Extension.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 07.12.2023.
//

import UIKit

extension UIImage {
	func image(alpha: CGFloat) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(size, false, scale)
		draw(at: .zero, blendMode: .normal, alpha: alpha)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage
	}
}
