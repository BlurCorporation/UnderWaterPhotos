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
    func buildAuthViewController() -> AuthViewController
}

final class SceneBuildManager {
}


extension SceneBuildManager: Buildable {
    func buildSubscriptionView() -> SubscriptionViewController {
        let viewController = SubscriptionViewController()

        return viewController
    }
    
    func buildAuthViewController() -> AuthViewController {
        let viewController = AuthViewController()
        let presenter = AuthPresenter(sceneBuildManager: self)
        
        viewController.presenter = presenter
        presenter.viewController = viewController
        
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
        let viewModel = MainViewModel()
        let viewController = MainViewController(viewModel: viewModel)
        
        return viewController
    }
    
    func buildLanguageScreen() -> LanguageSettingViewController {
        let viewController = LanguageSettingViewController()
        
        return viewController
    }
}
