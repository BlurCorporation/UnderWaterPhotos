//
//  LanguageSettingView.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 07.11.2023.
//

import UIKit

protocol LanguageSettingViewProtocol {
    
}

final class LanguageSettingViewController: UIViewController {
    
    var presenter: LanguageSettingPresenterProtocol?
    
    private var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "blueDark")
//        view.layer.cornerRadius = 
        
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "back"),
                        for: .normal)
        button.addTarget(self,
                         action: #selector(backButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
//        headerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 40)
    }
    
    
    @objc private func backButtonPressed() {
        presenter?.backButtonPressed()
    }
    
}

extension LanguageSettingViewController: LanguageSettingViewProtocol {
    
}

extension LanguageSettingViewController {
    func setupViewController() {
        addSubviews()
        setupConstraints()
        setupNavigationController()
        view.backgroundColor = .white
    }
    
    func setupNavigationController() {
        navigationItem.setHidesBackButton(true,
                                          animated: true)
        let backButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButton
        title = "Язык приложения"
        navigationController?.isNavigationBarHidden = false
    }
    
    func addSubviews() {
        view.addSubviews(headerView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 108)
        ])
    }
}
