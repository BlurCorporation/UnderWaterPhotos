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
    
    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Action
}

// MARK: - ExampleViewControllerProtocol Imp

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
