//
//  Presenter.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 03.09.2023.
//

import CoreImage
import UIKit

protocol PresenterProtocol: AnyObject {
    func changeImage(image: UIImage, value: Float)
}

class Presenter {
    weak var viewController: ViewControllerProtocol?
        
    //MARK: - PrivateProperties
    
    private let sceneBuildManager: Buildable
    private let imageProcessingManager: ImageProcessingProtocol
    
    //MARK: - Initialize
    
    init(sceneBuildManager: Buildable,
         imageProcessingManager: ImageProcessingProtocol) {
        self.sceneBuildManager = sceneBuildManager
        self.imageProcessingManager = imageProcessingManager
    }
    
    
}

extension Presenter: PresenterProtocol {
    func changeImage(image: UIImage, value: Float) {
        var newImage = UIImage()
        newImage = imageProcessingManager.adjustExposure(image: image, exposure: 0.2)
        newImage = imageProcessingManager.adjustContrast(image: newImage, contrast: 1.1)
        newImage = imageProcessingManager.adjustBrightnessForShadows(image: newImage, brightness: 0.2)
//        newImage = imageProcessingManager.adjustWhiteBalance(image: image, value)
//        newImage = imageProcessingManager.sharpenImage(image: image, sharpness: CGFloat(value))
//        newImage = imageProcessingManager.adjustBrightnessForHighlights(image: image, brightness: CGFloat(value))
//        newImage = imageProcessingManager.adjustHue(image: image, hue: CGFloat(value))
//        newImage = imageProcessingManager.adjustSaturation(image: image, saturation: CGFloat(value))
//        newImage = imageProcessingManager.adjustColorfulness(image: image, factor: CGFloat(value))
        viewController?.uploadImage(image: newImage)
    }
}
