//
//  Presenter.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 03.09.2023.
//

import CoreImage
import UIKit

protocol ProcessPresenterProtocol: AnyObject {
    func changeImage(image: UIImage, value: Float)
    func backButtonPressed()
}

class ProcessPresenter {
    weak var viewController: ProcessViewControllerProtocol?
        
    //MARK: - PrivateProperties
    
    private let sceneBuildManager: Buildable
    
    //MARK: - Initialize
    
    init(sceneBuildManager: Buildable) {
        self.sceneBuildManager = sceneBuildManager
    }
}

extension ProcessPresenter: ProcessPresenterProtocol {
    func backButtonPressed() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
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
