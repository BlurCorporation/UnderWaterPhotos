//
//  ImageProcessingManager.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 10.09.2023.
//

import UIKit
import CoreImage

protocol ImageProcessingProtocol {
    func adjustWhiteBalance(image: UIImage) -> UIImage
}

class ImageProcessing: ImageProcessingProtocol {
    func adjustWhiteBalance(image: UIImage) -> UIImage {
        let ciImage = CIImage(image: image)
        
        let filter = CIFilter(name: "CITemperatureAndTint")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(CIVector(x: 10000, y: 0), forKey: "inputTargetNeutral")
        
        if let outputImage = filter?.outputImage {
            let context = CIContext(options: nil)
            
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return UIImage(named: "emptyImage")!
    }
}
