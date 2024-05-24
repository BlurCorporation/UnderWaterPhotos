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
    func buildSaveBottomSheetViewController(processContentType: ProcessContentType,
                                            videoURL: String?,
                                            previewImage: UIImage?,
                                            defaultImage: UIImage?,
                                            processedImage: UIImage?) -> BottomSheetSaveViewController
}

final class SceneBuildManager {
    private let imageMergeManager = ImageMergeManager()
    private let repository = Repository()
    private let userDefaultsManager = DefaultsManager()
    private let customTransitioningDelegate = BSTransitioningDelegate()
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
        let isUserPremium = userDefaultsManager.fetchObject(type: Bool.self, for: .isUserPremium) ?? false
        let presenter = ProcessPresenter(sceneBuildManager: self,
                                         processContentType: processContenType,
                                         videoProcessingManager: videoProcessingManager,
                                         userDefaultsManager: userDefaultsManager,
                                         isUserPremium: isUserPremium)
        
        viewController.defaultVideoURL = url
        viewController.defaultImage = image
        viewController.imageMergeManager = imageMergeManager
//        viewController.repository = repository
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
    
    func buildSaveBottomSheetViewController(processContentType: ProcessContentType,
                                            videoURL: String?,
                                            previewImage: UIImage?,
                                            defaultImage: UIImage?,
                                            processedImage: UIImage?) -> BottomSheetSaveViewController {
        let vc = BottomSheetSaveViewController(
            processContentType: processContentType,
            userDefaultsManager: userDefaultsManager,
            repository: repository
        )
        vc.transitioningDelegate = customTransitioningDelegate
        vc.modalPresentationStyle = .custom
        
        if processContentType == .image {
            vc.addImage(image: defaultImage, processedImage: processedImage)
        }
        vc.addVideo(url: videoURL, previewImage: previewImage)
        vc.imageMergeManager = imageMergeManager
        return vc
    }
}
