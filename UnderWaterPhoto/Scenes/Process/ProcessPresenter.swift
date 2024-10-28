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

enum ProcessContentType {
	case image
	case video
}

protocol ProcessPresenterProtocol: AnyObject {
	func viewDidLoad()
	func changeImage(
		image: UIImage,
		url: String
	)
	func backButtonPressed()
	func shareButtonPressed()
	func showBottomSheetButtonPressed()
	func showSaveBottomSheet(
		processContentType: ProcessContentType,
		videoURL: String?,
		previewImage: UIImage?,
		defaultImage: UIImage?,
		processedImage: UIImage?,
		processedImageAlpha: Float
	)
}

class ProcessPresenter {
	weak var viewController: ProcessViewControllerProtocol?
	
	// MARK: - Dependencies
	
	private let sceneBuildManager: Buildable
	private let videoProcessingManager: VideoProcessingManagerProtocol
	private let userDefaultsManager: DefaultsManagerable
	
	//MARK: - PrivateProperties
	
	private var processButtonType: ProcessButtonType = .change
	private var processContentType: ProcessContentType
	private var previewImage: UIImage?
	private var videoURL: String?
	private var wasProcessed: Bool = false
	private let isUserPremium: Bool
	private let shouldProcessAfterViewDidLoad: Bool
	
	//MARK: - Initialize
	
	init(
		sceneBuildManager: Buildable,
		processContentType: ProcessContentType,
		videoProcessingManager: VideoProcessingManagerProtocol,
		userDefaultsManager: DefaultsManagerable,
		isUserPremium: Bool,
		shouldProcessAfterViewDidLoad: Bool
	) {
		self.sceneBuildManager = sceneBuildManager
		self.processContentType = processContentType
		self.videoProcessingManager = videoProcessingManager
		self.userDefaultsManager = userDefaultsManager
		self.isUserPremium = isUserPremium
		self.shouldProcessAfterViewDidLoad = shouldProcessAfterViewDidLoad
	}
}

extension ProcessPresenter: ProcessPresenterProtocol {
	func viewDidLoad() {
		switch processContentType {
		case .image:
			viewController?.setupImageProcessing()
			if shouldProcessAfterViewDidLoad {
				guard let image = viewController?.defaultImage else { return }
				self.changeImage(image: image, url: "")
			}
		case .video:
			viewController?.setupVideoProcessing()
		}
	}
	
	func backButtonPressed() {
		viewController?.navigationController?.popViewController(animated: true)
	}
	
	func shareButtonPressed() {
		switch processContentType {
		case .image:
			viewController?.shareImage()
		case .video:
			guard let stringURL = videoURL,
				  let url = URL(string: stringURL) else { return }
			viewController?.shareVideo(url)
		}
	}
	
	func showBottomSheetButtonPressed() {
		switch processContentType {
		case .image:
			viewController?.presentBottomSheet(processContentType: processContentType, videoURL: nil, previewImage: previewImage)
		case .video:
			viewController?.presentBottomSheet(processContentType: processContentType, videoURL: videoURL, previewImage: previewImage)
		}
	}
	
	func changeImage(image: UIImage, url: String) {
		switch processButtonType {
		case .change:
			processButtonType = .process
			viewController?.changeToProcess(with: processContentType)
			viewController?.makeConstraintsForWatermark(
				processContentType: processContentType
			)
			if !isUserPremium {
				viewController?.showWatermark()
			}
			self.viewController?.disableProcessButton()
			wasProcessed = true
			Task {
				switch processContentType {
				case .image:
					try await process(image: image)
				case .video:
					let isWatermark = !(userDefaultsManager.fetchObject(type: Bool.self, for: .isUserPremium) ?? false)
					try await process(
						video: String(url.dropFirst(7)),
						isWatermark: isWatermark
					)
				}
			}
		case .process:
			if processContentType == .image {
				viewController?.showBottomSaveSheet()
			} else {
				viewController?.routeMainScreen()
			}
		}
	}
	
	func showSaveBottomSheet(
		processContentType: ProcessContentType,
		videoURL: String?,
		previewImage: UIImage?,
		defaultImage: UIImage?,
		processedImage: UIImage?,
		processedImageAlpha: Float
	) {
		let viewController = sceneBuildManager.buildSaveBottomSheetViewController(
			processContentType: processContentType,
			videoURL: videoURL,
			previewImage: previewImage,
			defaultImage: defaultImage,
			processedImage: processedImage,
			processedImageAlpha: processedImageAlpha
		)
		
		self.viewController?.present(viewController, animated: true)
	}
	
	private func process(image: UIImage) async throws {
		viewController?.startIndicator()
		let newImage = try CVWrapper.process(withImages: image)
		if !(userDefaultsManager.fetchObject(type: Bool.self, for: .isUserPremium) ?? false) {
			
		}
		viewController?.uploadImage(image: newImage)
		viewController?.stopIndicator()
	}
	
	private func process(video: String, isWatermark: Bool) async throws {
		viewController?.startIndicator()
		videoProcessingManager.process(video, isWatermark: isWatermark) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let success):
				self.previewImage = success.image
				self.viewController?.changeVideo(url: URL(string: success.url!)!)
				self.videoURL = success.url
			case .failure(let failure):
				print(failure.localizedDescription)
			}
			self.viewController?.stopIndicator()
		}
	}
}
