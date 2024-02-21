//
//  SceneBuildManager.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 03.09.2023.
//

protocol Buildable {
    func buildProcessViewController(image: UIImage?,
                                    url: String?,
                                    processContenType: ProcessContentType) -> ProcessViewController
    func buildMainView() -> MainViewController
    func buildSubscriptionView() -> SubscriptionViewController
    func buildLanguageScreen() -> LanguageSettingViewController
    func buildAuthViewController() -> AuthViewController
}

final class SceneBuildManager {
    private let imageMergeManager = ImageMergeManager()
    private let repository = Repository()
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
    
    func buildProcessViewController(image: UIImage?,
                                    url: String?,
                                    processContenType: ProcessContentType) -> ProcessViewController {
        let videoProcessingManager = VideoProcessingManager()
        let viewController = ProcessViewController()
        let presenter = ProcessPresenter(sceneBuildManager: self,
                                         processContentType: processContenType,
                                         videoProcessingManager: videoProcessingManager)
        
        viewController.defaultVideoURL = url
        viewController.defaultImage = image
        viewController.imageMergeManager = imageMergeManager
        viewController.repository = repository
        viewController.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
    
    func buildMainView() -> MainViewController {
        let viewModel = MainViewModel(repository: Repository())
        let viewController = MainViewController(viewModel: viewModel)
        
        return viewController
    }
    
    func buildLanguageScreen() -> LanguageSettingViewController {
        let viewController = LanguageSettingViewController()
        
        return viewController
    }
}
