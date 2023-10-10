//
//  SceneBuildManager.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 03.09.2023.
//

protocol Buildable {
    func buildViewController() -> ViewController // тестовый vc
    func buildMainView() -> SubscriptionViewController // MainScreen на SwiftUI
}

final class SceneBuildManager {
}


extension SceneBuildManager: Buildable {
    func buildMainView() -> SubscriptionViewController {
        let viewController = SubscriptionViewController()
        
        return viewController
    }
    
    func buildViewController() -> ViewController {
        let viewController = ViewController()
        let presenter = Presenter(sceneBuildManager: self)
        
        viewController.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
    
    func buildMainView() -> MainViewController {
        let viewController = MainViewController()
        
        
        return viewController
    }
}
