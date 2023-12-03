//
//  Presenter.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 03.09.2023.
//

import CoreImage
import UIKit

enum ProcessButtonType {
    case change
    case process
}

protocol ProcessPresenterProtocol: AnyObject {
    func changeImage(image: UIImage, value: Float)
    func backButtonPressed()
}

class ProcessPresenter {
    weak var viewController: ProcessViewControllerProtocol?
        
    //MARK: - PrivateProperties
    
    private let sceneBuildManager: Buildable
    private var processButtonType: ProcessButtonType = .change
    
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
        switch processButtonType {
        case .change:
            processButtonType = .process
            viewController?.changeToProcess()
        case .process:
            viewController?.showBottomSaveSheet()
            Task {
                let newImage: UIImage = try await process(image: image)
                self.viewController?.uploadImage(image: newImage)
            }
        }
    }
    
    func process(image: UIImage) async throws -> UIImage{
        let newImage = try CVWrapper.process(withImages: image)
        return newImage
    }
}
