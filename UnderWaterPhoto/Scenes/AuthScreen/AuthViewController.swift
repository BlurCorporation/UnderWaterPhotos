//
//  AuthViewController.swift
//  UnderWaterPhoto
//
//  Created by Антон on 20.09.2023.
//

import UIKit

// MARK: - AuthViewControllerProtocol

protocol AuthViewControllerProtocol: UIViewController {
    func expand()
}

// MARK: - AuthViewController

final class AuthViewController: UIViewController {
    
    var presenter: AuthPresenterProtocol?
    
    // MARK: PrivateProperties
    
    private var isExpanded: Bool = false
    var loginButtonCenterYConstraint: NSLayoutConstraint!
    var registrationButtonCenterYConstraint: NSLayoutConstraint!
    
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

//func expand() {
//    if isExpanded {
//        UIView.animate(withDuration: 0.5) {
//            self.logoutButton.alpha = 0
//            self.deleteButton.alpha = 0
//            self.homeButtonCenterYConstraint.constant = 0
//            self.deleteButtonCenterYConstraint.constant = 0
//            self.view.layoutIfNeeded()
//            self.homeButton.setBackgroundImage(
//                UIImage(named: "homeButton"),
//                for: .normal
//            )
//        }
//    } else {
//        UIView.animate(withDuration: 0.5) {
//            self.logoutButton.alpha = 1
//            self.deleteButton.alpha = 1
//            self.homeButtonCenterYConstraint.constant = (self.homeButton.frame.width + 16)
//            self.deleteButtonCenterYConstraint.constant = ((self.homeButton.frame.width + 16) * 2)
//            self.view.layoutIfNeeded()
//            self.homeButton.setBackgroundImage(
//                UIImage(named: "backButton"),
//                for: .normal
//            )
//        }
//    }
//    isExpanded.toggle()
//}
extension AuthViewController: AuthViewControllerProtocol {
    func expand() {
        if isExpanded {
            UIView.animate(withDuration: 0.5) {
                self.loginButton.alpha = 0
                self.registrationButton.alpha = 0
                self.loginButtonCenterYConstraint.constant = 0
                self.registrationButtonCenterYConstraint.constant = 0
                self.view.layoutIfNeeded()
                
            }
            
        } else {}
    }
}

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
