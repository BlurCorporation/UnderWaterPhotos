//
//  SceneBuildManager.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 03.09.2023.
//

protocol Buildable {
    func buildViewController() -> ViewController // тестовый vc
    func buildMainView() -> MainViewController // MainScreen на SwiftUI
    func buildAuthViewController() -> AuthViewController 
}

final class SceneBuildManager {
    private let imageProcessingManager: ImageProcessingProtocol = ImageProcessing()
}


extension SceneBuildManager: Buildable {
    
    func buildAuthViewController() -> AuthViewController {
        let viewController = AuthViewController()
        let presenter = AuthPresenter(sceneBuildManager: self)
        
        viewController.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
    
    func buildViewController() -> ViewController {
        let viewController = ViewController()
        let presenter = Presenter(sceneBuildManager: self,
                                  imageProcessingManager: imageProcessingManager)
        
        viewController.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
    
    func buildMainView() -> MainViewController {
        let viewController = MainViewController()
        
        
        return viewController
    }
}
