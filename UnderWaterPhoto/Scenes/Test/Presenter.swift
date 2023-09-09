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
    private let imageProcessingManager: ImageProcessingProtocol
    
    //MARK: - Initialize
    
    init(sceneBuildManager: Buildable,
         imageProcessingManager: ImageProcessingProtocol) {
        self.sceneBuildManager = sceneBuildManager
        self.imageProcessingManager = imageProcessingManager
    }
    
    
}

extension Presenter: PresenterProtocol {
    func changeImage(image: UIImage) {
        var newImage = UIImage()
        newImage = imageProcessingManager.adjustWhiteBalance(image: image)
        
        viewController?.uploadImage(image: newImage)
    }
    
}
