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
    var defaultImage: UIImage?
    
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
        label.text = "Изменение"
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
//        button.addTarget(self,
//                         action: #selector(backButtonPressed),
//                         for: .touchUpInside)
        return button
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "blueDark")
        view.layer.cornerRadius = 40
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    private let mainImage: UIImageView = {
        let image = UIImage(named: "underwaterPhoto1")
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 255/255, green: 255/250, blue: 255/251, alpha: 0.08)
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
        button.setTitle("Убрать логотип", for: .normal)
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
        return button
    }()
    
    private lazy var processPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Изменить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(named: "white")
        button.tintColor = UIColor(named: "blue")
        button.addTarget(self, action: #selector(processButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = -1
        slider.maximumValue = 1
        slider.value = 0
        slider.addTarget(self, action: #selector(sliderChange(_ :)), for: .valueChanged)
        slider.minimumTrackTintColor = UIColor(named: "blue")
        slider.maximumTrackTintColor = UIColor(named: "white")
        slider.thumbTintColor = UIColor(named: "white")
        return slider
        
    }()
    
    private let bottomSaveSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "blueDark")
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var bottomSheetBackButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Назад", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.tintColor = UIColor(named: "white")
        button.addTarget(self, action: #selector(bottomSheetSaveButtonAction), for: .touchUpInside)
        return button
    }()
    
    private let bottomSheetSaveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.tintColor = UIColor(named: "white")
        return button
    }()
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        defaultImage = mainImage.image
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
        presenter?.changeImage(image: self.mainImage.image!, value: -3000)
    }
    
    @objc
    func sliderChange(_ sender: UISlider) {
        print(sender.value)
//        presenter?.changeImage(image: self.defaultImage!, value: sender.value)
    }
    @objc
    func bottomSheetSaveButtonAction() {
        UIView.animate(withDuration: 0.5) {
            self.topConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func changeToProcess() {
        titleLabel.text = "Редактирование"
        processPhotoButton.setTitle("Редактировать", for: .normal)
        hideLogoButton.isHidden = false
        filterButton.isHidden = false
        let shareBarButtonItem = UIBarButtonItem(systemItem: .action)
        shareBarButtonItem.tintColor = UIColor(named: "white")
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
            self.mainImage.image = image
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
                         mainImage,
                         slider,
                         hideLogoButton,
                         filterButton,
                         processPhotoButton,
                         bottomSaveSheetView)
        
        bottomSaveSheetView.addSubviews(slider, bottomSheetBackButton, bottomSheetSaveButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 108),
            
            mainImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainImage.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            mainImage.bottomAnchor.constraint(equalTo: hideLogoButton.topAnchor, constant: -13),

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
            
            bottomSaveSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSaveSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSaveSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            bottomSaveSheetView.heightAnchor.constraint(equalToConstant: 0),
            
            bottomSheetBackButton.leadingAnchor.constraint(equalTo: bottomSaveSheetView.leadingAnchor, constant: 20),
            bottomSheetBackButton.topAnchor.constraint(equalTo: bottomSaveSheetView.topAnchor, constant: 27),
            
            bottomSheetSaveButton.topAnchor.constraint(equalTo: bottomSaveSheetView.topAnchor, constant: 27),
            bottomSheetSaveButton.trailingAnchor.constraint(equalTo: bottomSaveSheetView.trailingAnchor, constant: -20),
            
            slider.bottomAnchor.constraint(equalTo: bottomSaveSheetView.bottomAnchor, constant: -55),
            slider.topAnchor.constraint(equalTo: bottomSaveSheetView.topAnchor, constant: 84),
            slider.trailingAnchor.constraint(equalTo: bottomSaveSheetView.trailingAnchor, constant: -16),
            slider.leadingAnchor.constraint(equalTo: bottomSaveSheetView.leadingAnchor, constant: 16)
        ])
        
        topConstraint = bottomSaveSheetView.topAnchor.constraint(equalTo: view.bottomAnchor)
        topConstraint.isActive = true
    }
}
