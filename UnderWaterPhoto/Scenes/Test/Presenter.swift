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
        
        Task {
            let newImage: UIImage = try await process(image: image)
            self.viewController?.uploadImage(image: newImage)
        }
    }
    
    func process(image: UIImage) async throws -> UIImage{
        let newImage = try CVWrapper.process(withImages: image)
        return newImage
    }
}
