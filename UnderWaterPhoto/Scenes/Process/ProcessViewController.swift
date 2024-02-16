//
//  ProcessViewController.swift
//  UnderWaterPhoyo
//
//  Created by Максим Косников on 03.09.2023.
//

import UIKit
import SnapKit

// MARK: - ProcessViewControllerProtocol

protocol ProcessViewControllerProtocol: UIViewController {
    func uploadImage(image: UIImage)
    func changeToProcess()
    func showBottomSaveSheet()
}

// MARK: - ProcessViewController

final class ProcessViewController: UIViewController {
    
    var presenter: ProcessPresenterProtocol?
    var imageMergeManager: ImageMergeManager?
    var repository: Repository?
    var defaultImage: UIImage?
    private var processedImage: UIImage?
    private var processedImageAlpha: Float = 0.8
    private var previousImageAlpha: Float = 0.8
    private let customTransitioningDelegate = BSTransitioningDelegate()
    
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
        label.text = L10n.ProcessViewController.TitleLabel.Label.text
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(named: "white")
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "arrow.down.to.line")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "white")
        button.addTarget(self,
                         action: #selector(presentVCAsBottomSheet),
                         for: .touchUpInside)
        return button
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
        return imageView
    }()
    
    private let processedImageView: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 40
        return imageView
    }()
    
    private lazy var hideLogoButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .small)
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.image = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        buttonConfig.imagePadding = 8
        button.configuration = buttonConfig
        button.setTitle(L10n.ProcessViewController.HideLogoButton.Button.title, for: .normal)
        button.tintColor = UIColor(named: "white")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.layer.cornerRadius = 20
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
        button.setTitle(L10n.ProcessViewController.ProcessPhotoButton.Button.title, for: .normal)
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
        button.setTitle(L10n.ProcessViewController.BottomSheetBackButton.Button.title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.tintColor = UIColor(named: "white")
        button.addTarget(self, action: #selector(bottomSheetBackButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var bottomSheetSaveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.ProcessViewController.BottomSheetSaveButton.Button.title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.tintColor = UIColor(named: "white")
        button.addTarget(self, action: #selector(bottomSheetSaveButtonAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        processedImage = defaultImage
        if let defaultImage {
            mainImageView.image = defaultImage
        }
        
        hideLogoButton.isHidden = true
        filterButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: Action
    @objc
    func backButtonPressed() {
        presenter?.backButtonPressed()
    }
    
    @objc
    func processButtonAction() {
        presenter?.changeImage(image: self.mainImageView.image!, value: -3000)
    }
    
    @objc func filterTouched() {
        processedImageView.isHidden = true
    }
    
    @objc func filterDidntTouched() {
        processedImageView.isHidden = false
    }
    
    @objc
    func sliderChange(_ sender: UISlider) {
        print(sender.value)
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
    
    @objc func shareAll() {
        guard let defaultImage = defaultImage,
              let topImage = processedImage?.image(alpha: CGFloat(processedImageAlpha)) else { return }
        let image = imageMergeManager?.mergeImages(bottomImage: defaultImage, topImage: topImage)
        let shareAll = [image!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
       }
    
    @objc
    func presentVCAsBottomSheet() {
        let vc = BottomSheetSaveViewController()
        vc.addImage(image: defaultImage, processedImage: processedImage?.image(alpha: CGFloat(processedImageAlpha)))
        vc.imageMergeManager = imageMergeManager
        vc.repository = repository
        vc.transitioningDelegate = customTransitioningDelegate
        vc.modalPresentationStyle = .custom
        present(vc, animated: true)
    }
    
    func changeToProcess() {
        titleLabel.text = L10n.ProcessViewController.ChangeToProcess.TitleLabel.text
        processPhotoButton.setTitle(L10n.ProcessViewController.ChangeToProcess.ProcessPhotoButton.title, for: .normal)
        hideLogoButton.isHidden = false
        filterButton.isHidden = false
        let shareBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAll))
        shareBarButtonItem.tintColor = UIColor(named: "white")
//        shareBarButtonItem.target = #selector(shareAll)
        let saveBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        navigationItem.rightBarButtonItems = [saveBarButtonItem, shareBarButtonItem]
    }
    
    func showBottomSaveSheet() {
        UIView.animate(withDuration: 0.5) {
            self.topConstraint.constant = -167
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - ProcessViewControllerProtocol Imp

extension ProcessViewController: ProcessViewControllerProtocol {
    func uploadImage(image: UIImage) {
        DispatchQueue.main.async {
            self.processedImage = image
            self.processedImageView.image = image
        }
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
        view.addSubviews(headerView,
                         mainImageView,
                         processedImageView,
                         slider,
                         hideLogoButton,
                         filterButton,
                         processPhotoButton,
                         processBottomSheetView)
        
        processBottomSheetView.addSubviews(slider,
                                           bottomSheetBackButton,
                                           bottomSheetSaveButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 108),
            
            mainImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainImageView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            mainImageView.bottomAnchor.constraint(equalTo: hideLogoButton.topAnchor, constant: -13),
            
            processedImageView.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor),
            processedImageView.topAnchor.constraint(equalTo: mainImageView.topAnchor),
            processedImageView.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),
            processedImageView.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor),

            hideLogoButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            hideLogoButton.widthAnchor.constraint(equalToConstant: 183),
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
            slider.leadingAnchor.constraint(equalTo: processBottomSheetView.leadingAnchor, constant: 16)
        ])
        
        topConstraint = processBottomSheetView.topAnchor.constraint(equalTo: view.bottomAnchor)
        topConstraint.isActive = true
    }
}
