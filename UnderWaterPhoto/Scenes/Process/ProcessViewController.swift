//
//  ProcessViewController.swift
//  UnderWaterPhoyo
//
//  Created by Максим Косников on 03.09.2023.
//

import UIKit
import SnapKit
import AVFoundation

// MARK: - ProcessViewControllerProtocol

protocol ProcessViewControllerProtocol: UIViewController {
	var defaultImage: UIImage? { get }
	
	func uploadImage(image: UIImage)
	func changeToProcess(with type: ProcessContentType)
	func showBottomSaveSheet()
	func changeVideo(url: URL)
	func setupImageProcessing()
	func setupVideoProcessing()
	func shareImage()
	func shareVideo(_ video: URL)
	func presentBottomSheet(
		processContentType: ProcessContentType,
		videoURL: String?,
		previewImage: UIImage?
	)
	func startIndicator()
	func stopIndicator()
	func makeConstraintsForWatermark(
		processContentType: ProcessContentType
	)
	func showWatermark()
	func hideWatermark()
	func disableProcessButton()
	func routeMainScreen()
}

// MARK: - ProcessViewController

final class ProcessViewController: UIViewController {
	
	var presenter: ProcessPresenterProtocol?
	var imageMergeManager: ImageMergeManager?
	var defaultImage: UIImage?
	var defaultVideoURL: String?
	private var processedImage: UIImage?
	var processedImageAlpha: Float = 0.8
	var previousImageAlpha: Float = 0.8
	private var isWatermark: Bool = true
	
	// MARK: PrivateProperties
	
	private var topConstraint: NSLayoutConstraint!
	
	private lazy var backButton: UIButton = {
		let button = UIButton(type: .system)
		let image = UIImage(systemName: "chevron.left")
		button.setImage(image, for: .normal)
		button.tintColor = UIColor(named: "white")
		button.addTarget(self,
						 action: #selector(backButtonPressed),
						 for: .touchUpInside)
		return button
	}()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.text = L10n.ProcessVC.TitleLabel.Label.text
		label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
		label.textColor = UIColor(named: "white")
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()
	
	private lazy var shareBarButtonItem: UIBarButtonItem = {
		let item = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonPressed))
		item.tintColor = UIColor(named: "white")
		return item
	}()
	
	private lazy var saveBarButtonItem: UIBarButtonItem = {
		let button = UIButton(type: .system)
		let image = UIImage(systemName: "arrow.down.to.line")
		button.setImage(image, for: .normal)
		button.tintColor = UIColor(named: "white")
		button.addTarget(self,
						 action: #selector(presentVCAsBottomSheet),
						 for: .touchUpInside)
		let item = UIBarButtonItem(customView: button)
		return item
	}()
	
	private let headerView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(named: "blueDark")
		view.layer.cornerRadius = 40
		view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
		return view
	}()
	
	private let mainImageView: UIImageView = {
		let image = UIImage()
		let imageView = UIImageView()
		imageView.backgroundColor = UIColor(red: 255/255, green: 255/250, blue: 255/251, alpha: 0.08)
		imageView.image = image
		imageView.contentMode = .scaleAspectFit
		imageView.layer.cornerRadius = 40
		imageView.clipsToBounds = true
		return imageView
	}()
	
	private let playerView: VideoLooperView = {
		let player = VideoLooperView()
		player.videoPlayerView.playerLayer.cornerRadius = 40
		player.videoPlayerView.playerLayer.videoGravity = .resizeAspect
		player.videoPlayerView.playerLayer.masksToBounds = true
		player.videoPlayerView.backgroundColor = UIColor(red: 255/255, green: 255/250, blue: 255/251, alpha: 0.08)
		return player
	}()
	
	private let processedImageView: UIImageView = {
		let image = UIImage()
		let imageView = UIImageView()
		imageView.image = image
		imageView.contentMode = .scaleAspectFit
		imageView.layer.cornerRadius = 40
		imageView.clipsToBounds = true
		return imageView
	}()
	
	private lazy var hideLogoButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle(L10n.ProcessVC.HideLogoButton.Button.title, for: .normal)
		button.tintColor = UIColor(named: "white")
		button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
		button.addTarget(self, action: #selector(hideLogoButtonAction), for: .touchUpInside)
		button.isHidden = true
		return button
	}()
	
	private lazy var filterButton: UIButton = {
		let button = UIButton(type: .system)
		let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .small)
		button.setImage(UIImage(systemName: "trapezoid.and.line.vertical", withConfiguration: imageConfig), for: .normal)
		button.tintColor = UIColor(named: "white")
		button.layer.cornerRadius = 20
		button.addTarget(self, action: #selector(filterTouched), for: .touchDown)
		button.addTarget(self, action: #selector(filterDidntTouched), for: .touchUpInside)
		return button
	}()
	
	private lazy var processPhotoButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle(L10n.ProcessVC.ProcessPhotoButton.Button.title, for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
		button.layer.cornerRadius = 16
		button.backgroundColor = UIColor(named: "white")
		button.tintColor = UIColor(named: "blue")
		button.addTarget(self, action: #selector(processButtonAction), for: .touchUpInside)
		return button
	}()
	
	private lazy var slider: UISlider = {
		let slider = UISlider()
		slider.minimumValue = 0
		slider.maximumValue = 1
		slider.value = processedImageAlpha
		slider.addTarget(self, action: #selector(sliderChange(_ :)), for: .valueChanged)
		slider.minimumTrackTintColor = UIColor(named: "blue")
		slider.maximumTrackTintColor = UIColor(named: "white")
		slider.thumbTintColor = UIColor(named: "white")
		return slider
		
	}()
	
	private let processBottomSheetView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(named: "blueDark")
		view.layer.cornerRadius = 16
		view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		return view
	}()
	
	private lazy var bottomSheetBackButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle(L10n.ProcessVC.BottomSheetBackButton.Button.title, for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
		button.tintColor = UIColor(named: "white")
		button.addTarget(self, action: #selector(bottomSheetBackButtonAction), for: .touchUpInside)
		return button
	}()
	
	private lazy var bottomSheetSaveButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle(L10n.ProcessVC.BottomSheetSaveButton.Button.title, for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
		button.tintColor = UIColor(named: "white")
		button.addTarget(self, action: #selector(bottomSheetSaveButtonAction), for: .touchUpInside)
		return button
	}()
	
	private lazy var activityIndicator: UIActivityIndicatorView = {
		let activityIndicator =  UIActivityIndicatorView(style: .large)
		activityIndicator.color = .white
		return activityIndicator
	}()
	
	private let watermarkImageView: UIImageView = {
		let image = UIImage(named: "watermark")
		let imageView = UIImageView(image: image)
		imageView.isHidden = true
		return imageView
	}()
	
	// MARK: LifeCycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViewController()
		self.startIndicator()
		processedImage = defaultImage
		
		if let defaultImage {
			mainImageView.image = defaultImage
		}
		
		
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			if let url = URL(string: self.defaultVideoURL ?? "") {
				self.playerView.addVideo(video: url)
				self.playerView.play {
					self.stopIndicator()
				}
			}
		}
		
//		hideLogoButton.isHidden = true
		filterButton.isHidden = true
//		watermarkImageView.isHidden = true
		processedImageView.alpha = CGFloat(self.processedImageAlpha)
		presenter?.viewDidLoad()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.isNavigationBarHidden = false
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			self.playerView.pause()
		}
	}
	
	// MARK: Action
	
	@objc
	func backButtonPressed() {
		presenter?.backButtonPressed()
	}
	
	@objc
	func processButtonAction() {
		presenter?.changeImage(
			image: self.mainImageView.image!,
			url: defaultVideoURL ?? ""
		)
	}
	
	@objc func filterTouched() {
		let path = UIBezierPath(
			rect: CGRect(
				x: 0,
				y: 0,
				width: processedImageView.frame.width / 2,
				height: processedImageView.frame.height
			)
		)
		let mask = CAShapeLayer()
		mask.path = path.cgPath
		mask.fillRule = CAShapeLayerFillRule.evenOdd
		processedImageView.layer.mask = mask
	}
	
	@objc func filterDidntTouched() {
		processedImageView.layer.mask = nil
	}
	
	@objc
	func sliderChange(_ sender: UISlider) {
		processedImageView.alpha = CGFloat(sender.value)
		processedImageAlpha = sender.value
	}
	
	@objc
	func bottomSheetBackButtonAction() {
		processedImageView.alpha = CGFloat(previousImageAlpha)
		slider.value = previousImageAlpha
		UIView.animate(withDuration: 0.35) {
			self.topConstraint.constant = 0
			self.view.layoutIfNeeded()
		}
	}
	
	@objc
	func bottomSheetSaveButtonAction() {
		previousImageAlpha = processedImageAlpha
		UIView.animate(withDuration: 0.35) {
			self.topConstraint.constant = 0
			self.view.layoutIfNeeded()
		}
	}
	
	@objc func shareButtonPressed() {
		presenter?.shareButtonPressed()
	}
	
	@objc
	func presentVCAsBottomSheet() {
		presenter?.showBottomSheetButtonPressed()
	}
	
	@objc
	func hideLogoButtonAction() {
		self.watermarkImageView.isHidden = isWatermark
		isWatermark.toggle()
	}
}

// MARK: - ProcessViewControllerProtocol Imp

extension ProcessViewController: ProcessViewControllerProtocol {
	func startIndicator() {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			self.saveBarButtonItem.isEnabled = false
			self.shareBarButtonItem.isEnabled = false
			self.processPhotoButton.isEnabled = false
			self.filterButton.isEnabled = false
			self.hideLogoButton.isEnabled = false
			self.bottomSheetBackButton.isEnabled = false
			self.bottomSheetSaveButton.isEnabled = false
			self.slider.isEnabled = false
			print("start\n\(Date())")
			self.activityIndicator.startAnimating()
		}
	}
	
	func stopIndicator() {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			self.saveBarButtonItem.isEnabled = true
			self.shareBarButtonItem.isEnabled = true
			self.processPhotoButton.isEnabled = true
			self.filterButton.isEnabled = true
			self.hideLogoButton.isEnabled = true
			self.bottomSheetBackButton.isEnabled = true
			self.bottomSheetSaveButton.isEnabled = true
			self.slider.isEnabled = true
			print("stop\n\(Date())")
			self.activityIndicator.stopAnimating()
		}
	}
	
	func presentBottomSheet(
		processContentType: ProcessContentType,
		videoURL: String?,
		previewImage: UIImage?
	) {
		self.presenter?.showSaveBottomSheet(
			processContentType: processContentType,
			videoURL: videoURL,
			previewImage: previewImage,
			defaultImage: defaultImage,
			processedImage: processedImage,//?.image(alpha: CGFloat(processedImageAlpha))
			processedImageAlpha: processedImageAlpha
		)
	}
	
	func setupImageProcessing() {
		playerView.isHidden = true
	}
	
	func setupVideoProcessing() {
		mainImageView.isHidden = true
		filterButton.isHidden = true
	}
	
	func changeVideo(url: URL) {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			self.hideWatermark()
			self.playerView.addVideo(video: url)
			self.playerView.play {
				self.stopIndicator()
			}
		}
	}
	
	func uploadImage(image: UIImage) {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			self.processedImage = image
			self.processedImageView.image = image
		}
	}
	
	func changeToProcess(with contentType: ProcessContentType) {
		titleLabel.text = L10n.ProcessVC.ChangeToProcess.TitleLabel.text
		switch contentType {
		case .image:
			processPhotoButton.setTitle(L10n.ProcessVC.ProcessPhotoButton.Edit.title, for: .normal)
			filterButton.isHidden = false
		case .video:
			processPhotoButton.setTitle(L10n.ProcessVC.ProcessVideoButton.GoMainScene.title, for: .normal)
		}
		navigationItem.rightBarButtonItems = [saveBarButtonItem, shareBarButtonItem]
	}
	
	func shareImage() {
		guard let defaultImage = defaultImage,
			  let topImage = processedImage?.image(alpha: CGFloat(processedImageAlpha)) else { return }
		let image = imageMergeManager?.mergeImages(bottomImage: defaultImage, topImage: topImage)
		let shareAll = [image!] as [Any]
		let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
		activityViewController.popoverPresentationController?.sourceView = self.view
		self.present(activityViewController, animated: true, completion: nil)
	}
	
	func shareVideo(_ video: URL) {
		let objectsToShare = [video]
		let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
		activityVC.setValue("Video", forKey: "subject")
		activityVC.popoverPresentationController?.sourceView = self.view
		
		self.present(activityVC, animated: true, completion: nil)
	}
	
	func showBottomSaveSheet() {
		UIView.animate(withDuration: 0.5) {
			self.topConstraint.constant = -167
			self.view.layoutIfNeeded()
		}
	}
	
	func makeConstraintsForWatermark(processContentType: ProcessContentType) {
		switch processContentType {
		case .image:
			let imageRect = AVMakeRect(aspectRatio: mainImageView.image!.size, insideRect: mainImageView.frame)
			let leadingConstant = abs(mainImageView.frame.width - imageRect.width)
			/ 2
			+ 32
			let bottomConstant = -(
				abs(mainImageView.frame.height - imageRect.height)
				/ 2
				+ 32
			)
			
			NSLayoutConstraint.activate([
				watermarkImageView.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor, constant: leadingConstant),
				watermarkImageView.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: bottomConstant)
			])
		case .video:
			let leadingConstant = abs(playerView.frame.width - playerView.videoPlayerView.playerLayer.videoRect.width)
			/ 2
			+ 32
			let bottomConstant = -(
				abs(playerView.frame.height - playerView.videoPlayerView.playerLayer.videoRect.height)
				/ 2
				+ 32
			)
			
			NSLayoutConstraint.activate([
				watermarkImageView.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: leadingConstant),
				watermarkImageView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor, constant: bottomConstant)
			])
		}
		
		self.view.layoutIfNeeded()
	}
	
	func showWatermark() {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			self.hideLogoButton.isHidden = false
			self.watermarkImageView.isHidden = false
		}
	}
	
	func hideWatermark() {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			self.hideLogoButton.isHidden = true
			self.watermarkImageView.isHidden = true
		}
	}
	
	func disableProcessButton() {
		self.processPhotoButton.isEnabled = false
	}
	
	func routeMainScreen() {
		self.navigationController?.popViewController(animated: true)
	}
}

// MARK: - PrivateMethods

extension ProcessViewController {
	func setupViewController() {
		addSubviews()
		setupConstraints()
		setupNavigationController()
		view.backgroundColor = UIColor(named: "blue")
	}
	
	func setupNavigationController() {
		navigationItem.setHidesBackButton(true,
										  animated: true)
		let backButton = UIBarButtonItem(customView: backButton)
		navigationItem.leftBarButtonItem = backButton
		navigationItem.titleView = titleLabel
		navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 213, height: 29)
	}
	
	func addSubviews() {
		view.addSubviews(
			headerView,
			playerView,
			mainImageView,
			processedImageView,
			slider,
			hideLogoButton,
			filterButton,
			processPhotoButton,
			processBottomSheetView,
			activityIndicator,
			watermarkImageView
		)
		
		processBottomSheetView.addSubviews(
			slider,
			bottomSheetBackButton,
			bottomSheetSaveButton
		)
	}
	
	func setupConstraints() {
		NSLayoutConstraint.activate([
			headerView.topAnchor.constraint(equalTo: view.topAnchor),
			headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			headerView.heightAnchor.constraint(equalToConstant: 108),
			
			playerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			playerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			playerView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
			playerView.bottomAnchor.constraint(equalTo: hideLogoButton.topAnchor, constant: -13),
			
			mainImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			mainImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			mainImageView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
			mainImageView.bottomAnchor.constraint(equalTo: hideLogoButton.topAnchor, constant: -13),
			
			processedImageView.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor),
			processedImageView.topAnchor.constraint(equalTo: mainImageView.topAnchor),
			processedImageView.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),
			processedImageView.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor),
			
			hideLogoButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			hideLogoButton.widthAnchor.constraint(equalToConstant: hideLogoButton.intrinsicContentSize.width + 36),
			hideLogoButton.bottomAnchor.constraint(equalTo: processPhotoButton.topAnchor, constant: -28),
			hideLogoButton.heightAnchor.constraint(equalToConstant: 50),
			
			filterButton.topAnchor.constraint(equalTo: hideLogoButton.topAnchor),
			filterButton.bottomAnchor.constraint(equalTo: hideLogoButton.bottomAnchor),
			filterButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			filterButton.widthAnchor.constraint(equalToConstant: 56),
			
			processPhotoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
			processPhotoButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			processPhotoButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			processPhotoButton.heightAnchor.constraint(equalToConstant: 50),
			
			processBottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			processBottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			processBottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			
			bottomSheetBackButton.leadingAnchor.constraint(equalTo: processBottomSheetView.leadingAnchor, constant: 20),
			bottomSheetBackButton.topAnchor.constraint(equalTo: processBottomSheetView.topAnchor, constant: 27),
			
			bottomSheetSaveButton.topAnchor.constraint(equalTo: processBottomSheetView.topAnchor, constant: 27),
			bottomSheetSaveButton.trailingAnchor.constraint(equalTo: processBottomSheetView.trailingAnchor, constant: -20),
			
			slider.bottomAnchor.constraint(equalTo: processBottomSheetView.bottomAnchor, constant: -55),
			slider.topAnchor.constraint(equalTo: processBottomSheetView.topAnchor, constant: 84),
			slider.trailingAnchor.constraint(equalTo: processBottomSheetView.trailingAnchor, constant: -16),
			slider.leadingAnchor.constraint(equalTo: processBottomSheetView.leadingAnchor, constant: 16),
			
			activityIndicator.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor),
		])
		
		topConstraint = processBottomSheetView.topAnchor.constraint(equalTo: view.bottomAnchor)
		topConstraint.isActive = true
	}
}
