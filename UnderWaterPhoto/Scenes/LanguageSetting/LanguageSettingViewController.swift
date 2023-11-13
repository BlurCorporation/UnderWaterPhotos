//
//  LanguageSettingView.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 07.11.2023.
//

import UIKit

final class LanguageSettingViewController: UIViewController {
    
    private var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "blueDark")
//        view.layer.cornerRadius = 
        
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
//        headerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 40)
    }
    
    
}

extension LanguageSettingViewController {
    func setupViewController() {
        addSubviews()
        setupConstraints()
        setupNavigationController()
        view.backgroundColor = .white
    }
    
    func setupNavigationController() {
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
