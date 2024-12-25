import UIKit
import Photos

final class BottomSheetSaveViewController: UIViewController {
	
	// MARK: - Dependencies
	
	var imageMergeManager: ImageMergeManager?
	private var repository: RepositoryProtocol
	private let userDefaultsManager: DefaultsManagerable
	
	// MARK: - Private properties
	
	private var defaultImage: UIImage?
	private var processedImage: UIImage?
	private var videoURL: String?
	private var previewImage: UIImage?
	private var processContentType: ProcessContentType
	private var alphaSetting: Float?
	
	// MARK: - UI Elements
	
	private let saveInAppLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor(named: "white")
		label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
		label.text = L10n.BottomSheetSaveVC.SaveInAppLabel.Label.text
		label.numberOfLines = 0
		return label
	}()
	
	private let saveOnPhoneLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor(named: "white")
		label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
		label.text = L10n.BottomSheetSaveVC.SaveOnPhoneLabel.Label.text
		label.numberOfLines = 0
		return label
	}()
	
	private lazy var bottomSheetBackButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle(L10n.BottomSheetSaveVC.BottomSheetBackButton.Button.setTitle, for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
		button.tintColor = UIColor(named: "white")
		button.addTarget(self, action: #selector(back), for: .touchUpInside)
		return button
	}()
	
	private lazy var bottomSheetSaveButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle(L10n.BottomSheetSaveVC.BottomSheetSaveButton.Button.setTitle, for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
		button.tintColor = UIColor(named: "white")
		button.addTarget(self, action: #selector(save), for: .touchUpInside)
		return button
	}()
	
	private let inAppSwitch: UISwitch = {
		let uiswitch = UISwitch()
		uiswitch.isOn = true
		return uiswitch
	}()
	
	private let onPhoneSwitch: UISwitch = {
		let uiswitch = UISwitch()
		uiswitch.isOn = true
		return uiswitch
	}()
	
	// MARK: - Lifecycle
	
	init(
		processContentType: ProcessContentType,
		userDefaultsManager: DefaultsManagerable,
		repository: RepositoryProtocol
	) {
		self.processContentType = processContentType
		self.userDefaultsManager = userDefaultsManager
		self.repository = repository
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor(named: "blueDark")
		view.layer.cornerRadius = 16
		view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		
		view.addSubviews(
			bottomSheetSaveButton,
			bottomSheetBackButton,
			saveInAppLabel,
			saveOnPhoneLabel,
			onPhoneSwitch,
			inAppSwitch
		)
		NSLayoutConstraint.activate([
			bottomSheetBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			bottomSheetBackButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
			
			bottomSheetSaveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
			bottomSheetSaveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			
			saveInAppLabel.topAnchor.constraint(equalTo: bottomSheetBackButton.bottomAnchor, constant: 38),
			saveInAppLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			
			inAppSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			inAppSwitch.centerYAnchor.constraint(equalTo: saveInAppLabel.centerYAnchor),
			
			saveOnPhoneLabel.topAnchor.constraint(equalTo: saveInAppLabel.bottomAnchor, constant: 22),
			saveOnPhoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			saveOnPhoneLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
			
			onPhoneSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			onPhoneSwitch.centerYAnchor.constraint(equalTo: saveOnPhoneLabel.centerYAnchor),
		])
	}
	
	// MARK: - Private methods
	
	private func saveInApp() {
		switch processContentType {
		case .image:
			guard let defaultImage = defaultImage,
				  let processedImage = processedImage else { return }
			let mergedImage = imageMergeManager?.mergeImages(bottomImage: defaultImage, topImage: processedImage)
            guard let finalImage = mergedImage else { return }
//			if !(userDefaultsManager.fetchObject(type: Bool.self, for: .isUserPremium) ?? false) {
//				finalImage = imageMergeManager?.mergeWatermark(image: finalImage) ?? UIImage()
//			}
			repository.addContent(
				defaultImage: defaultImage,
				processedImage: finalImage,
				processedAlphaSetting: alphaSetting,
				processedVideoTempURL: nil
			)
		case .video:
			guard let image = previewImage, let url = videoURL else { return }
			repository.addContent(
				defaultImage: nil,
				processedImage: image,
				processedAlphaSetting: nil,
				processedVideoTempURL: url
			)
		}
	}
	
	private func saveOnPhone() {
		switch processContentType {
		case .image:
            guard let defaultImage = defaultImage,
				  let processedImage = processedImage else { return }
			let mergedImage = imageMergeManager?.mergeImages(bottomImage: defaultImage, topImage: processedImage)
            guard let finalImage = mergedImage else { return }
			UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
		case .video:
			guard let url = videoURL else { print("error"); return }
			PHPhotoLibrary.shared().performChanges {
				PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(string: url)!)
			}
		}
	}
	
	// MARK: - Actions
	
	@objc func back() {
		presentingViewController?.dismiss(animated: true)
	}
	
	@objc func save() {
		if inAppSwitch.isOn {
			self.saveInApp()
		}
		if onPhoneSwitch.isOn {
			self.saveOnPhone()
		}
		presentingViewController?.dismiss(animated: true)
	}
	
	// MARK: - Internal Methods
	
	func addImage(defaultImage: UIImage?, processedImage: UIImage?, alphaSetting: Float) {
		self.defaultImage = defaultImage
		self.processedImage = processedImage
		self.alphaSetting = alphaSetting
	}
	
	func addVideo(videoURL: String?, previewImage: UIImage?) {
		self.videoURL = videoURL
		self.previewImage = previewImage
	}
}
