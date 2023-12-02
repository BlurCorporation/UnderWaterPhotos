//
//  ProcessViewController.swift
//  UnderWaterPhoyo
//
//  Created by Максим Косников on 03.09.2023.
//

import UIKit
import PhotosUI


// MARK: - ProcessViewControllerProtocol

protocol ProcessViewControllerProtocol: UIViewController {
    func uploadImage(image: UIImage)
}

// MARK: - ProcessViewController

final class ProcessViewController: UIViewController {
    
    var presenter: ProcessPresenterProtocol?
    var defaultImage: UIImage?
    
    // MARK: PrivateProperties
    
    private var imagePicker = UIImagePickerController()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "back")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "white")
        
        button.addTarget(self,
                         action: #selector(backButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Язык приложения"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(named: "white")
        return label
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
    
    private lazy var uploadPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Загрузить фото", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemBlue
        button.tintColor = UIColor(named: "white")
        button.addTarget(self, action: #selector(uploadButtonAction), for: .touchUpInside)
        return button
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
    
    private lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Изменить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(named: "white")
        button.tintColor = UIColor(named: "blue")
        button.addTarget(self, action: #selector(changeButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = -1
        slider.maximumValue = 1
        slider.value = 0
        slider.addTarget(self, action: #selector(sliderChange(_ :)), for: .valueChanged)
        return slider
        
    }()
    
    
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        defaultImage = mainImage.image
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
    func changeButtonAction() {
        presenter?.changeImage(image: self.mainImage.image!, value: -3000)
    }
    
    @objc
    func sliderChange(_ sender: UISlider) {
        print(sender.value)
        presenter?.changeImage(image: self.defaultImage!, value: sender.value)
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
        navigationItem.setHidesBackButton(true,
                                          animated: true)
        let backButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.titleView = titleLabel
    }
    
    func setupNavigationController() {
        title = "Редактирование"
    }
    
    func addSubviews() {
        view.addSubviews(headerView,
                         mainImage,
                         slider,
                         uploadPhotoButton,
                         hideLogoButton,
                         filterButton,
                         changePhotoButton)
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
            
//            uploadPhotoButton.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -16),
//            uploadPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

//            slider.bottomAnchor.constraint(equalTo: changePhotoButton.topAnchor, constant: -16),
//            slider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
//            slider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),

            hideLogoButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            hideLogoButton.widthAnchor.constraint(equalToConstant: 183),
            hideLogoButton.bottomAnchor.constraint(equalTo: changePhotoButton.topAnchor, constant: -28),
            hideLogoButton.heightAnchor.constraint(equalToConstant: 50),
            
            filterButton.topAnchor.constraint(equalTo: hideLogoButton.topAnchor),
            filterButton.bottomAnchor.constraint(equalTo: hideLogoButton.bottomAnchor),
            filterButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            filterButton.widthAnchor.constraint(equalToConstant: 56),
            
            changePhotoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            changePhotoButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            changePhotoButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            changePhotoButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension ProcessViewController: PHPickerViewControllerDelegate {
    @objc
    func uploadButtonAction() {
        var config = PHPickerConfiguration()
        config.filter = PHPickerFilter.images
        

        let pickerViewController = PHPickerViewController(configuration: config)
        
        
        pickerViewController.delegate = self
        self.present(pickerViewController, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
           for result in results {
              result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                 if let image = object as? UIImage {
                     DispatchQueue.main.async {
                         self.mainImage.image = image
                         self.defaultImage = self.mainImage.image
                     }
                 }
              })
           }
    }
}
