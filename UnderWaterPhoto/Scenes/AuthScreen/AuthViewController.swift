//
//  AuthViewController.swift
//  UnderWaterPhoto
//
//  Created by Антон on 20.09.2023.
//

import UIKit

// MARK: - AuthViewControllerProtocol

protocol AuthViewControllerProtocol: UIViewController {}

// MARK: - AuthViewController

final class AuthViewController: UIViewController {
    
    var presenter: AuthPresenterProtocol?
    
    // MARK: PrivateProperties
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(registrationButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var appleIdButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(appleIdButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var googleIdButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(googleIdButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Action
    
    @objc
    func loginButtonPressed() {
        presenter?.loginButtonPressed()
    }
    
    @objc
    func registrationButtonPressed() {
        presenter?.registrationButtonPressed()
    }
    
    @objc
    func appleIdButtonPressed() {
        presenter?.appleIdButtonPressed()
    }
    
    @objc
    func googleIdButtonPressed() {
        presenter?.googleIdButtonPressed()
    }
}

// MARK: - AuthViewControllerProtocol Imp

extension AuthViewController: AuthViewControllerProtocol {}

// MARK: - PrivateMethods

private extension AuthViewController {
    
    func setupViewController() {
        addSubviews()
        setupConstraints()
        setupNavigationController()
    }
    
    func setupNavigationController() {}
    
    func addSubviews() {}
    
    func setupConstraints() {
        NSLayoutConstraint.activate([])
    }
}
