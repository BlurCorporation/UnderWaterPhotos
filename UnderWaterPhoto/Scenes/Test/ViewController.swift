//
//  ViewController.swift
//  UnderWaterPhoyo
//
//  Created by Максим Косников on 03.09.2023.
//

import UIKit
import PhotosUI


// MARK: - ViewControllerProtocol

protocol ViewControllerProtocol: UIViewController {
    func uploadImage(image: UIImage)
}

// MARK: - ViewController

final class ViewController: UIViewController {
    
    var presenter: PresenterProtocol?
    var defaultImage: UIImage?
    
    // MARK: PrivateProperties
    
    private var imagePicker = UIImagePickerController()
    
    private let mainImage: UIImageView = {
        let image = UIImage(named: "emptyImage")
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let commonStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        return stack
    }()
    
    private lazy var uploadPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Загрузить фото", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.addTarget(self, action: #selector(uploadButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отредактировать", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.addTarget(self, action: #selector(changeButtonAction), for: .touchUpInside)
        return button
    }()
    
    private let buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.distribution = .fillEqually
        return stack
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
    
    // MARK: Action
    
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

// MARK: - ViewControllerProtocol Imp

extension ViewController: ViewControllerProtocol {
    func uploadImage(image: UIImage) {
        DispatchQueue.main.async {
            self.mainImage.image = image
        }
    }
}

// MARK: - PrivateMethods

extension ViewController {
    func setupViewController() {
        addSubviews()
        setupConstraints()
        setupNavigationController()
        view.backgroundColor = .white
    }
    
    func setupNavigationController() {
        
    }
    
    func addSubviews() {
        view.addSubviews(commonStackView, buttonsStackView, slider)
        
        commonStackView.addArrangedSubviews(mainImage)
        
        buttonsStackView.addArrangedSubviews(uploadPhotoButton,
                                             changePhotoButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // commonStackView with mainImage
            commonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: commonStackView.trailingAnchor, constant: 16),
            commonStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            commonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200),
            // buttonsStackView
            buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor, constant: 16),
            buttonsStackView.topAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: 16),
            // slider
            slider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            slider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            slider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
}

extension ViewController: PHPickerViewControllerDelegate {
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
