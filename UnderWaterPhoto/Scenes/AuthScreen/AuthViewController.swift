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

protocol AuthViewControllerProtocol: UIViewController {}

// MARK: - AuthViewController

final class AuthViewController: UIViewController {
    
    var presenter: AuthPresenterProtocol?
    
    // MARK: PrivateProperties
    
    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .blue
        return label
    }()
    
    private lazy var headTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
    
    func addSubviews() {
        view.addSubview(headTitle)
        view.addSubview(textFieldStackView)
        view.addSubview(loginButton)
        view.addSubview(registrationButton)
        view.addSubview(loginUsinLabel)
        view.addSubview(appleIdButton)
        view.addSubview(googleIdButton)
        view.addSubview(logoLabel)
        
        textFieldStackView.addArrangedSubview(nameTextField)
        textFieldStackView.addArrangedSubview(emailTextField)
        textFieldStackView.addArrangedSubview(passwordTextField)
        textFieldStackView.addArrangedSubview(repeatPasswordTextField)
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
        
        textFieldStackView.snp.makeConstraints { make in
            make.top.equalTo(headTitle.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(343)
            
        }
        
        nameTextField.snp.makeConstraints { make in
            make.width.equalTo(343)
            make.height.equalTo(44)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.width.equalTo(343)
            make.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.width.equalTo(343)
            make.height.equalTo(44)
        }
        
        repeatPasswordTextField.snp.makeConstraints { make in
            make.width.equalTo(343)
            make.height.equalTo(44)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(repeatPasswordTextField.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.width.equalTo(88)
            make.height.equalTo(50)
        }
        
        registrationButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(28)
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
