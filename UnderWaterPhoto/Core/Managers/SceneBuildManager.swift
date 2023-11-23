//
//  SceneBuildManager.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 03.09.2023.
//

protocol Buildable {
    func buildViewController() -> ViewController // тестовый vc
    func buildMainView() -> MainViewController // MainScreen на SwiftUI
    func buildSubscriptionView() -> SubscriptionViewController
    func buildLanguageScreen() -> LanguageSettingViewController
}

final class SceneBuildManager {
}


extension SceneBuildManager: Buildable {
    func buildSubscriptionView() -> SubscriptionViewController {
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
    
    func buildLanguageScreen() -> LanguageSettingViewController {
        let viewController = LanguageSettingViewController()
        let presenter = LanguageSettingPresenter(sceneBuildManager: self)
        
        viewController.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
