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
    func changeImage(image: UIImage, value: Float, url: String)
    func backButtonPressed()
    func shareButtonPressed()
    func showBottomSheetButtonPressed()
    func showSaveBottomSheet(processContentType: ProcessContentType,
                             videoURL: String?,
                             previewImage: UIImage?,
                             defaultImage: UIImage?,
                             processedImage: UIImage?)
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
    //MARK: - Initialize
    
    init(sceneBuildManager: Buildable,
         processContentType: ProcessContentType,
         videoProcessingManager: VideoProcessingManagerProtocol,
         userDefaultsManager: DefaultsManagerable,
         isUserPremium: Bool) {
        self.sceneBuildManager = sceneBuildManager
        self.processContentType = processContentType
        self.videoProcessingManager = videoProcessingManager
        self.userDefaultsManager = userDefaultsManager
        self.isUserPremium = isUserPremium
    }
}

extension ProcessPresenter: ProcessPresenterProtocol {
    func viewDidLoad() {
        switch processContentType {
        case .image:
            viewController?.setupImageProcessing()
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
    
    func changeImage(image: UIImage, value: Float, url: String) {
        switch processButtonType {
        case .change:
            processButtonType = .process
            viewController?.changeToProcess()
            if !isUserPremium {
                viewController?.showWatermark()
            }
        case .process:
            viewController?.showBottomSaveSheet()
            if !wasProcessed {
                wasProcessed = true
                Task {
                    switch processContentType {
                    case .image:
                        try await process(image: image)
                    case .video:
                        try await process(video: String(url.dropFirst(7)))
                    }
                }
            }
        }
    }
    
    func showSaveBottomSheet(processContentType: ProcessContentType,
                             videoURL: String?,
                             previewImage: UIImage?,
                             defaultImage: UIImage?,
                             processedImage: UIImage?) {
        let viewController = sceneBuildManager.buildSaveBottomSheetViewController(processContentType: processContentType, videoURL: videoURL, previewImage: previewImage, defaultImage: defaultImage, processedImage: processedImage)
        
        self.viewController?.present(viewController, animated: true)
    }
    
    private func process(image: UIImage) async throws {
        viewController?.startIndicator()
        let newImage = try CVWrapper.process(withImages: image)
        let _newImage = UIImage(cgImage: newImage.cgImage!, scale: image.scale, orientation: image.imageOrientation)
        viewController?.uploadImage(image: _newImage)
        viewController?.stopIndicator()
    }
    
    private func process(video: String) async throws {
        viewController?.startIndicator()
        videoProcessingManager.process(video) { [weak self] result in
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
