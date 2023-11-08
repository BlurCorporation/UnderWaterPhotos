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
    private var passwordTextFieldCenterYConstraint: Constraint?
    private var emailTextFieldCenterYConstraint: Constraint?
    private var loginButtonCenterYConstraint: Constraint?
    private var registrationButtonCenterYConstrain: Constraint?
    
    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .blue
        return label
    }()
    
    private lazy var headTitle: UILabel = {
        let label = UILabel()
        label.text = "Создать аккаунт"
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = UIColor(named: "backgroundColorRegistrationButton")
        return label
    }()
    
    private lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = CastomTextField()
        textField.placeholder = "Имя".localized
        return textField
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = CastomTextField()
        textField.placeholder = "E-mail".localized
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = CastomTextField()
        textField.placeholder = "Пароль".localized
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var repeatPasswordTextField: UITextField = {
        let textField = CastomTextField()
        textField.placeholder = "Повторите пароль".localized
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var loginButton: CastomButton = {
        let button = CastomButton(frame: .zero)
        button.type = .loginButton
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        button.setTitle("Войти", for: .normal)
        return button
    }()
    
    private lazy var registrationButton: CastomButton = {
        let button = CastomButton(frame: .zero)
        button.type = .registrationButton
        button.addTarget(self, action: #selector(registrationButtonPressed), for: .touchUpInside)
        button.setTitle("Зарегистрироваться", for: .normal)
        return button
    }()
    
    private lazy var restorePasswordButton: CastomButton = {
        let button = CastomButton(frame: .zero)
        button.type = .loginButton
        button.alpha = 0
        button.addTarget(self, action: #selector(restorePasswordButtonPressed), for: .touchUpInside)
        button.setTitle("Восстановить пароль", for: .normal)
        return button
    }()
    
    private lazy var loginUsinLabel: UILabel = {
        let label = UILabel()
        label.text = "Войти с помощью"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    
    private lazy var appleIdButton: CastomButton = {
        let button = CastomButton(frame: .zero)
        button.type = .idBitton
        button.addTarget(self, action: #selector(appleIdButtonPressed), for: .touchUpInside)
        button.setBackgroundImage(UIImage(named: "appleLogo"), for: .normal)
        return button
    }()
    
    private lazy var googleIdButton: CastomButton = {
        let button = CastomButton(frame: .zero)
        button.type = .idBitton
        button.addTarget(self, action: #selector(googleIdButtonPressed), for: .touchUpInside)
        button.setBackgroundImage(UIImage(named: "googleLogo"), for: .normal)
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
        presenter?.loginButtonPressed()
    }
    
    @objc
    func registrationButtonPressed() {
        presenter?.registrationButtonPressed()
    }
    
    @objc
    func restorePasswordButtonPressed() {
        presenter?.restorePasswordButtonPressed()
    }
    
    @objc
    func appleIdButtonPressed() {
        presenter?.appleIdButtonPressed()
    }
    
    @objc
    func googleIdButtonPressed() {
        presenter?.googleIdButtonPressed()
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
            self.registrationButton.setTitle("Зарегестрироваться", for: .normal)
            self.headTitle.text = "Создать аккаунт"
            self.loginButton.setTitle("Войти", for: .normal)
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
            self.registrationButton.setTitle("Войти", for: .normal)
            self.headTitle.text = "Добро пожаловать"
            self.loginButton.setTitle("Регистрация", for: .normal)
            self.restorePasswordButton.setTitle("Восстановить пароль", for: .normal)
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
        self.registrationButton.setTitle("Восстановить пароль", for: .normal)
        self.headTitle.text = "Восстановить пароль"
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
        view.addSubview(logoLabel)
        view.addSubview(headTitle)
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(repeatPasswordTextField)
        view.addSubview(loginButton)
        view.addSubview(restorePasswordButton)
        view.addSubview(registrationButton)
        view.addSubview(loginUsinLabel)
        view.addSubview(appleIdButton)
        view.addSubview(googleIdButton)
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
            make.leading.equalToSuperview()
            make.width.equalTo(88)
            make.height.equalTo(50)
        }
        
        restorePasswordButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(8)
            make.trailing.equalToSuperview()
            make.width.equalTo(210)
            make.height.equalTo(50)
        }
        
        registrationButton.snp.makeConstraints { make in
            registrationButtonCenterYConstrain = make.top.equalTo(headTitle.snp.bottom).offset(350).constraint
            make.centerX.equalToSuperview()
            make.width.equalTo(343)
            make.height.equalTo(50)
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

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
