import UIKit
import Photos

final class BottomSheetSaveViewController: UIViewController {
    
    private var image: UIImage?
    private var processedImage: UIImage?
    private var videoURL: String?
    private var previewImage: UIImage?
    private var processContentType: ProcessContentType
    var imageMergeManager: ImageMergeManager?
    var repository: Repository?
    
    private let saveInAppLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "white")
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.text = L10n.BottomSheetSaveViewController.SaveInAppLabel.Label.text
        label.numberOfLines = 0
        return label
    }()
    
    private let saveOnPhoneLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "white")
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.text = L10n.BottomSheetSaveViewController.SaveOnPhoneLabel.Label.text
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bottomSheetBackButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.BottomSheetSaveViewController.BottomSheetBackButton.Button.setTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.tintColor = UIColor(named: "white")
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    
    private lazy var bottomSheetSaveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.BottomSheetSaveViewController.BottomSheetSaveButton.Button.setTitle, for: .normal)
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
    
    init(processContentType: ProcessContentType) {
        self.processContentType = processContentType
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
    
    func addVideo(url: String?, previewImage: UIImage?) {
        videoURL = url
        self.previewImage = previewImage
    }
    
    @objc func back() {
        presentingViewController?.dismiss(animated: true)
    }
    
    @objc func save() {
        if inAppSwitch.isOn {
            switch processContentType {
            case .image:
                guard let image = image else { return }
                if let processedImage = processedImage {
                    guard let finalImage = imageMergeManager?.mergeImages(bottomImage: image, topImage: processedImage) else { return }
                    repository?.addContent(uiimage: finalImage)
                } else {
                    repository?.addContent(uiimage: image)
                }
            case .video:
                guard let image = previewImage, let url = videoURL else { return }
                repository?.addContent(uiimage: image, url: url)
            }
        }
        
        if onPhoneSwitch.isOn {
            switch processContentType {
            case .image:
                guard let image = image else { return }
                if let processedImage = processedImage {
                    guard let finalImage = imageMergeManager?.mergeImages(bottomImage: image, topImage: processedImage) else { return }
                    UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
                } else {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
            case .video:
                guard let url = videoURL else { return }
                PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(string: url)!)
                }
                
            }
        }
        
        presentingViewController?.dismiss(animated: true)
    }
}
