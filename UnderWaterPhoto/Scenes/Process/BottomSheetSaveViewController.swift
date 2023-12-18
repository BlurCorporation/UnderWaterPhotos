import UIKit

final class BottomSheetSaveViewController: UIViewController {
    
    private var image: UIImage? = nil
    private var processedImage: UIImage? = nil
    var imageMergeManager: ImageMergeManager?
    var repository: Repository?
    
    private let saveInAppLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "white")
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.text = "Сохранить в приложении"
        label.numberOfLines = 0
        return label
    }()
    
    private let saveOnPhoneLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "white")
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.text = "Сохранить на устрйоство"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bottomSheetBackButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Назад", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.tintColor = UIColor(named: "white")
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    
    private lazy var bottomSheetSaveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "blueDark")
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        view.addSubviews(bottomSheetSaveButton,
                         bottomSheetBackButton,
                         saveInAppLabel,
                         saveOnPhoneLabel,
                         onPhoneSwitch,
                         inAppSwitch)
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
    
    func addImage(image: UIImage?, processedImage: UIImage?) {
        self.image = image
        self.processedImage = processedImage
    }
    
    @objc func back() {
        presentingViewController?.dismiss(animated: true)
    }
    
    @objc func save() {
        
        if inAppSwitch.isOn {
            guard let image = image else { return }
            if let processedImage = processedImage {
                guard let finalImage = imageMergeManager?.mergeImages(bottomImage: image, topImage: processedImage) else { return }
                repository?.addImage(uiimage: finalImage)
            } else {
                repository?.addImage(uiimage: image)
            }
        }
        if onPhoneSwitch.isOn {
            guard let image = image else { return }
            if let processedImage = processedImage {
                guard let finalImage = imageMergeManager?.mergeImages(bottomImage: image, topImage: processedImage) else { return }
                UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
            } else {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            
        }
        
        presentingViewController?.dismiss(animated: true)
    }
}
