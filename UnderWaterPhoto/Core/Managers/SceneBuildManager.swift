//
//  SceneBuildManager.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 03.09.2023.
//

protocol Buildable {
	func buildProcessViewController(
		defaultImage: UIImage?,
		image: UIImage?,
		alphaSetting: Float?,
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
	private let repository: RepositoryProtocol
	private let userDefaultsManager: DefaultsManagerable
	private let customTransitioningDelegate = BSTransitioningDelegate()
	private let authState: AuthState
	private let authService: AuthServicable
	private let firebaseStorageManager: FirebaseStorageManagerProtocol
	private let firestoreService: FirestoreServiceProtocol
	
	init(userDefaultsManager: DefaultsManagerable) {
		self.userDefaultsManager = userDefaultsManager
		self.firestoreService = FirestoreService()
		self.authService = AuthService(
			defaultsManager: self.userDefaultsManager,
			firestoreService: self.firestoreService
		)
		self.authState = AuthState.registration
		self.firebaseStorageManager = FirebaseStorageManager(
			authService: self.authService
		)
		self.repository = Repository(
			firebaseStorageManager: self.firebaseStorageManager,
			firestoreService: self.firestoreService
		)
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
		defaultImage: UIImage?,
		image: UIImage?,
		alphaSetting: Float?,
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
			isUserPremium: isUserPremium, 
			shouldProcessAfterViewDidLoad: defaultImage != nil
		)
		
		viewController.defaultVideoURL = url
		switch processContenType {
		case .image:
			if let defaultImage = defaultImage {
				viewController.defaultImage = defaultImage
			} else {
				viewController.defaultImage = image
			}
		case .video:
			viewController.defaultImage = image
		}
		viewController.processedImageAlpha = alphaSetting ?? 0.8
		viewController.previousImageAlpha = alphaSetting ?? 0.8
		viewController.imageMergeManager = imageMergeManager
		viewController.presenter = presenter
		presenter.viewController = viewController
		
		return viewController
	}
	
	func buildMainView() -> MainViewController {
		let viewModel = MainViewModel(
			repository: self.repository,
			userDefaultsManager: self.userDefaultsManager,
			authService: self.authService
		)
		let viewController = MainViewController(
			viewModel: viewModel,
			sceneBuildManager: self,
			defaultsManager: self.userDefaultsManager,
			repository: self.repository,
			authService: self.authService
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
				defaultImage: defaultImage,
				processedImage: processedImage,
				alphaSetting: processedImageAlpha
			)
		}
		vc.addVideo(videoURL: videoURL, previewImage: previewImage)
		vc.imageMergeManager = imageMergeManager
		return vc
	}
}
