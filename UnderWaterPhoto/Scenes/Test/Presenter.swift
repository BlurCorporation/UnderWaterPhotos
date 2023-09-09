//
//  Presenter.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 03.09.2023.
//

import CoreImage
import UIKit

protocol PresenterProtocol: AnyObject {
    func changeImage(image: UIImage)
}

class Presenter {
    weak var viewController: ViewControllerProtocol?
        
    //MARK: - PrivateProperties
    
    private let sceneBuildManager: Buildable
    
    //MARK: - Initialize
    
    init(sceneBuildManager: Buildable) {
        self.sceneBuildManager = sceneBuildManager
    }
    
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

extension Presenter: PresenterProtocol {
    func changeImage(image: UIImage) {
        var newImage = UIImage()
        newImage = adjustWhiteBalance(image: image)
        
        viewController?.uploadImage(image: newImage)
    }
    
}
