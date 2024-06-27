//
//  SceneBuildManager.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 03.09.2023.
//

protocol Buildable {
    func buildProcessViewController(
        image: UIImage?,
        url: String?,
        processContenType: ProcessContentType
    ) -> ProcessViewController
    func buildMainView() -> MainViewController
    func buildSubscriptionView() -> SubscriptionViewController
    func buildLanguageScreen() -> LanguageSettingViewController
    func buildAuthViewController() -> AuthViewController
    func buildSaveBottomSheetViewController(
        processContentType: ProcessContentType,
        videoURL: String?,
        previewImage: UIImage?,
        defaultImage: UIImage?,
        processedImage: UIImage?,
        processedImageAlpha: Float
    ) -> BottomSheetSaveViewController
}

final class SceneBuildManager {
    private let imageMergeManager = ImageMergeManager()
    private let repository = Repository()
    private let userDefaultsManager: DefaultsManagerable
    private let customTransitioningDelegate = BSTransitioningDelegate()
    private let authState: AuthState
    private let authService: AuthServicable
    
    init(userDefaultsManager: DefaultsManagerable) {
        self.userDefaultsManager = userDefaultsManager
        self.authService = AuthService(defaultsManager: self.userDefaultsManager)
        self.authState = AuthState.registration
    }
}

extension SceneBuildManager: Buildable {
    func buildSubscriptionView() -> SubscriptionViewController {
        let viewController = SubscriptionViewController()

        return viewController
    }
    
    func buildAuthViewController() -> AuthViewController {
        let viewController = AuthViewController()
        let presenter = AuthPresenter(
            sceneBuildManager: self,
            authState: self.authState,
            authService: self.authService,
            defaultsManager: self.userDefaultsManager
        )
        
        viewController.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
    
    func buildProcessViewController(
        image: UIImage?,
        url: String?,
        processContenType: ProcessContentType
    ) -> ProcessViewController {
        let videoProcessingManager = VideoProcessingManager(imageMergeManager: imageMergeManager)
        let viewController = ProcessViewController()
        let isUserPremium = userDefaultsManager.fetchObject(type: Bool.self, for: .isUserPremium) ?? false
        let presenter = ProcessPresenter(
            sceneBuildManager: self,
            processContentType: processContenType,
            videoProcessingManager: videoProcessingManager,
            userDefaultsManager: userDefaultsManager,
            isUserPremium: isUserPremium
        )
        
        viewController.defaultVideoURL = url
        viewController.defaultImage = image
        viewController.imageMergeManager = imageMergeManager
        viewController.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
    
    func buildMainView() -> MainViewController {
        let viewModel = MainViewModel(repository: repository)
        let viewController = MainViewController(
            viewModel: viewModel,
            sceneBuildManager: self,
            defaultsManager: self.userDefaultsManager,
            repository: self.repository
        )
        
        return viewController
    }
    
    func buildLanguageScreen() -> LanguageSettingViewController {
        let viewController = LanguageSettingViewController()
        
        return viewController
    }
    
    func buildSaveBottomSheetViewController(
        processContentType: ProcessContentType,
        videoURL: String?,
        previewImage: UIImage?,
        defaultImage: UIImage?,
        processedImage: UIImage?,
        processedImageAlpha: Float
    ) -> BottomSheetSaveViewController {
        let vc = BottomSheetSaveViewController(
            processContentType: processContentType,
            userDefaultsManager: userDefaultsManager,
            repository: repository
        )
        vc.transitioningDelegate = customTransitioningDelegate
        vc.modalPresentationStyle = .custom
        
        if processContentType == .image {
            let processedImage = processedImage?.image(alpha: CGFloat(processedImageAlpha))
            vc.addImage(
                image: defaultImage,
                processedImage: processedImage
            )
        }
        vc.addVideo(url: videoURL, previewImage: previewImage)
        vc.imageMergeManager = imageMergeManager
        return vc
    }
}
