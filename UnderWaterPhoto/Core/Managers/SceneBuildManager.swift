//
//  SceneBuildManager.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 03.09.2023.
//

protocol Buildable {
    func buildProcessViewController(image: UIImage?) -> ProcessViewController
    func buildMainView() -> MainViewController
    func buildSubscriptionView() -> SubscriptionViewController
    func buildLanguageScreen() -> LanguageSettingViewController
    func buildAuthViewController() -> AuthViewController
}

final class SceneBuildManager {
    private let imageMergeManager = ImageMergeManager()
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
    
    func buildProcessViewController(image: UIImage?) -> ProcessViewController {
        let viewController = ProcessViewController()
        let presenter = ProcessPresenter(sceneBuildManager: self)
        
        viewController.defaultImage = image
        viewController.imageMergeManager = imageMergeManager
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
