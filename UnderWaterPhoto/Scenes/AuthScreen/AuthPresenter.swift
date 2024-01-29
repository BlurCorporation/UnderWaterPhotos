//
//  AuthPresenter.swift
//  UnderWaterPhoto
//
//  Created by Антон on 20.09.2023.
//
import UIKit

// MARK: - AuthPresenterProtocol

protocol AuthPresenterProtocol: AnyObject {
    func loginButtonPressed()
    func registrationButtonPressed(name: String?,
                                   email: String?,
                                   password: String?,
                                   repeatPassword: String?)
    func restorePasswordButtonPressed()
    func appleIdButtonPressed()
    func googleIdButtonPressed()
    func changeState(authState: AuthState)
}

// MARK: - AuthPresenter

final class AuthPresenter {
    weak var viewController: AuthViewControllerProtocol?
    
    //MARK: - PrivateProperties
    
    private let sceneBuildManager: Buildable
    private var authState: AuthState
    private let authService: AuthServicable
    private let defaultsManager: DefaultsManagerable
    
    //MARK: - Initialize
    
    init(sceneBuildManager: Buildable,
         authState: AuthState,
         authService: AuthServicable,
         defaultsManager: DefaultsManagerable) {
        self.sceneBuildManager = sceneBuildManager
        self.authState = authState
        self.authService = authService
        self.defaultsManager = defaultsManager
    }
}

// MARK: - AuthPresenterProtocol Imp

extension AuthPresenter: AuthPresenterProtocol {
    func changeState(authState: AuthState) {
        self.authState = authState
    }
    
    func loginButtonPressed() {
        viewController?.expandLoginButton()
    }
    
    func registrationButtonPressed(name: String?,
                                   email: String?,
                                   password: String?,
                                   repeatPassword: String?) {
        guard let name = name,
              let email = email,
              let password = password,
              let repeatPassword = repeatPassword else { //toDo: проверяем password == repeatPassword?
            return
        }
        
        switch authState {
        case .registration:
            let newUser = RegisterUserRequest(name: name, email: email, password: password, repeatPassword: repeatPassword)
            
            self.authService.registerUser(with: newUser) { wasRegistered, error in
                if let error = error {
                    print(error.localizedDescription)
                    let alertController = UIAlertController(title: "Ошибка",
                                                            message: error.localizedDescription,
                                                            preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK",
                                                 style: .default,
                                                 handler: nil)
                    alertController.addAction(okAction)
                    self.viewController?.present(alertController,
                                                 animated: true,
                                                 completion: nil)
                    return
                }
                self.defaultsManager.saveObject(true,
                                                for: .isUserAuth)
            }
        case .login:
            let user = LoginUserRequest(email: email,
                                        password: password)
            
            authService.loginUser(with: user, typeAuth: .email, viewController: nil) { error in
                if let error = error {
                    print(error.localizedDescription)
                    let alertController = UIAlertController(title: "Ошибка",
                                                            message: error.localizedDescription,
                                                            preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK",
                                                 style: .default,
                                                 handler: nil)
                    alertController.addAction(okAction)
                    self.viewController?.present(alertController,
                                                 animated: true,
                                                 completion: nil)
                    return
                }
                self.defaultsManager.saveObject(true,
                                                for: .isUserAuth)
            }
        case .restore:
            break
        }
    }
    
    func restorePasswordButtonPressed() {
        viewController?.restorePasswordExpand()
    }
    
    func appleIdButtonPressed() {
        print("appleIdButtonAPressed")
    }
    
    func googleIdButtonPressed() {
        print("googleIdButtonPressed")
    }
}
