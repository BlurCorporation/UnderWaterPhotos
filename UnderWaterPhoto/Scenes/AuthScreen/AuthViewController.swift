//
//  AuthViewController.swift
//  UnderWaterPhoto
//
//  Created by Антон on 20.09.2023.
//

import UIKit
import SnapKit
import Foundation

// MARK: - AuthViewControllerProtocol

protocol AuthViewControllerProtocol: UIViewController {
    func expandLoginButton()
    func restorePasswordExpand()
}

// MARK: - AuthViewController

final class AuthViewController: UIViewController {
    
    var presenter: AuthPresenterProtocol?
    
    // MARK: PrivateProperties
    private var isExpandedLoginButton: Bool = false
    private let screenHeight = UIScreen.main.bounds.height
    private var passwordTextFieldCenterYConstraint: Constraint?
    private var emailTextFieldCenterYConstraint: Constraint?
    private var loginButtonCenterYConstraint: Constraint?
    private var registrationButtonCenterYConstrain: Constraint?
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .blue
        return label
    }()

    private let headTitle: UILabel = {
        let label = UILabel()
        label.text = L10n.AuthViewController.HeadTitle.text.localized
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = UIColor(named: L10n.AuthViewController.HeadTitle.textColor)
        return label
    }()
    
    private let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()
    
    private let nameTextField: UITextField = {
        let textField = CustomTextField()
        textField.placeholder = L10n.AuthViewController.nameTextField.localized
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = CustomTextField()
        textField.placeholder = L10n.AuthViewController.emailTextField.localized
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = CustomTextField()
        textField.placeholder = L10n.AuthViewController.passwordTextField.localized
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let repeatPasswordTextField: UITextField = {
        let textField = CustomTextField()
        textField.placeholder = L10n.AuthViewController.repeatPasswordTextField.localized
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var loginButton: CustomButton = {
        let button = CustomButton(frame: .zero)
        button.type = .loginButton
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        button.setTitle(L10n.AuthViewController.LoginButton.setTitle.localized, for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var registrationButton: CustomButton = {
        let button = CustomButton(frame: .zero)
        button.type = .registrationButton
        button.addTarget(self, action: #selector(registrationButtonPressed), for: .touchUpInside)
        button.setTitle(L10n.AuthViewController.RegistrationButton.setTitle.localized, for: .normal)
        return button
    }()
    
    private lazy var restorePasswordButton: CustomButton = {
        let button = CustomButton(frame: .zero)
        button.type = .loginButton
        button.alpha = .zero
        button.addTarget(self, action: #selector(restorePasswordButtonPressed), for: .touchUpInside)
        button.setTitle(L10n.AuthViewController.RestorePasswordButton.setTitle.localized, for: .normal)
        return button
    }()
    
    private let loginUsinLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.AuthViewController.LoginUsinLabel.text.localized
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    
    private lazy var appleIdButton: CustomButton = {
        let button = CustomButton(frame: .zero)
        button.type = .idButton
        button.addTarget(self, action: #selector(appleIdButtonPressed), for: .touchUpInside)
        button.setBackgroundImage(UIImage(named: L10n.AuthViewController.AppleIdButton.SetBackgroundImage.name), for: .normal)
        return button
    }()
    
    private lazy var googleIdButton: CustomButton = {
        let button = CustomButton(frame: .zero)
        button.type = .idButton
        button.addTarget(self, action: #selector(googleIdButtonPressed), for: .touchUpInside)
        button.setBackgroundImage(UIImage(named: L10n.AuthViewController.GoogleIdButton.SetBackgroundImage.name), for: .normal)
        return button
    }()
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        setupViewController()
    }
    
    // MARK: Action
    
    @objc
    func loginButtonPressed() {
        loginButton.pushAnimate { [weak self] in
            self?.presenter?.loginButtonPressed()
        }
    }
    
    @objc
    func registrationButtonPressed() {
        registrationButton.pushAnimate { [weak self] in
            self?.presenter?.registrationButtonPressed()
        }
    }
    
    @objc
    func restorePasswordButtonPressed() {
        restorePasswordButton.pushAnimate { [weak self] in
            self?.presenter?.restorePasswordButtonPressed()
        }
    }
    
    @objc
    func appleIdButtonPressed() {
        appleIdButton.pushAnimate { [weak self] in
            self?.presenter?.appleIdButtonPressed()
        }
    }
    
    @objc
    func googleIdButtonPressed() {
        googleIdButton.pushAnimate { [weak self] in
            self?.presenter?.googleIdButtonPressed()
        }
    }
    
    func expandLoginButton() {
        if isExpandedLoginButton {
            UIView.animate(withDuration: 0.5) {
                self.nameTextField.alpha = 1
                self.passwordTextField.alpha = 1
                self.repeatPasswordTextField.alpha = 1
                self.restorePasswordButton.alpha = 0
                self.emailTextFieldCenterYConstraint?.update(offset: 100)
                self.passwordTextFieldCenterYConstraint?.update(offset: 160)
                self.loginButtonCenterYConstraint?.update(offset: 272)
                self.registrationButtonCenterYConstrain?.update(offset: 350)
                self.view.layoutIfNeeded()
            }
            self.registrationButton.setTitle(L10n.AuthViewController.If.ExpandLoginButton.RegistrationButton.title.localized, for: .normal)
            self.headTitle.text = L10n.AuthViewController.If.ExpandLoginButton.HeadTitle.text.localized
            self.loginButton.setTitle(L10n.AuthViewController.If.ExpandLoginButton.LoginButton.title.localized, for: .normal)
        } else {
            UIView.animate(withDuration: 0.5) {
                self.nameTextField.alpha = 0
                self.repeatPasswordTextField.alpha = 0
                self.restorePasswordButton.alpha = 1
                self.emailTextFieldCenterYConstraint?.update(offset: 40)
                self.passwordTextFieldCenterYConstraint?.update(offset: 100)
                self.loginButtonCenterYConstraint?.update(offset: 152)
                self.registrationButtonCenterYConstrain?.update(offset: 230)
                self.view.layoutIfNeeded()
            }
            self.registrationButton.setTitle(L10n.AuthViewController.Else.ExpandLoginButton.RegistrationButton.title.localized, for: .normal)
            self.headTitle.text = L10n.AuthViewController.Else.ExpandLoginButton.HeadTitle.text.localized
            self.loginButton.setTitle(L10n.AuthViewController.Else.ExpandLoginButton.LoginButton.title.localized, for: .normal)
            self.restorePasswordButton.setTitle(L10n.AuthViewController.Else.ExpandLoginButton.RestorePasswordButton.title.localized, for: .normal)
        }
        isExpandedLoginButton.toggle()
    }
    
    func restorePasswordExpand() {
        UIView.animate(withDuration: 0.5) {
            self.passwordTextField.alpha = 0
            self.restorePasswordButton.alpha = 0
            self.loginButtonCenterYConstraint?.update(offset: 92)
            self.registrationButtonCenterYConstrain?.update(offset: 170)
            self.view.layoutIfNeeded()
        }
        self.registrationButton.setTitle(L10n.AuthViewController.RestorePasswordExpand.RegistrationButton.title.localized, for: .normal)
        self.headTitle.text = L10n.AuthViewController.RestorePasswordExpand.HeadTitle.text.localized
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
    
    func addSubviews() {
        view.addSubviews(logoLabel,
                         headTitle,
                         nameTextField,
                         emailTextField,
                         passwordTextField,
                         repeatPasswordTextField,
                         loginButton,
                         restorePasswordButton,
                         registrationButton,
                         loginUsinLabel,
                         appleIdButton,
                         googleIdButton)
    }
    
    func setupConstraints() {
        logoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(108)
        }
        
        headTitle.snp.makeConstraints { make in
            make.top.equalTo(logoLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(343)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(headTitle.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(44)
        }
        
        emailTextField.snp.makeConstraints { make in
            emailTextFieldCenterYConstraint = make.top.equalTo(headTitle.snp.bottom).offset(100).constraint
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints { make in
            passwordTextFieldCenterYConstraint = make.top.equalTo(headTitle.snp.bottom).offset(160).constraint
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(44)
        }
        
        repeatPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(44)
        }
        
        loginButton.snp.makeConstraints { make in
            loginButtonCenterYConstraint = make.top.equalTo(headTitle.snp.bottom).offset(272).constraint
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(142)
            make.height.equalTo(50)
        }
        
        restorePasswordButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(8) //TODO: maybe  make.top.equalTo(repeatPasswordTextField.snp.bottom).offset(8)
            make.trailing.equalToSuperview()
            make.width.equalTo(210)
            make.height.equalTo(50)
        }
        
        registrationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(343)
            make.height.equalTo(50)
            if screenHeight < 700 {
                registrationButtonCenterYConstrain = make.top.equalTo(headTitle.snp.bottom).offset(220).constraint
            } else {
                registrationButtonCenterYConstrain = make.top.equalTo(headTitle.snp.bottom).offset(350).constraint
            }
        }
        
        loginUsinLabel.snp.makeConstraints { make in
            make.top.equalTo(registrationButton.snp.bottom).offset(82)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(134)
            make.height.equalTo(20)
        }
        
        appleIdButton.snp.makeConstraints { make in
            make.top.equalTo(loginUsinLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(57.24)
            make.height.equalTo(50)
        }
        
        googleIdButton.snp.makeConstraints { make in
            make.top.equalTo(loginUsinLabel.snp.bottom).offset(16)
            make.leading.equalTo(appleIdButton.snp.trailing).offset(31.71)
            make.width.equalTo(62)
            make.height.equalTo(50)
        }
    }
}
