//
//  AuthPresenter.swift
//  UnderWaterPhoto
//
//  Created by Антон on 20.09.2023.
//
import UIKit

// MARK: - AuthPresenterProtocol

protocol AuthPresenterProtocol: AnyObject {
    func loginButtonPressed(name: String?,
                            email: String?,
                            password: String?,
                            repeatPassword: String?)
    func registrationButtonPressed()
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
    
    func loginButtonPressed(name: String?, email: String?, password: String?, repeatPassword: String?) {
        guard let email = email,
              let password = password else {
            return
        }
        
        switch authState {
        case .registration:
            viewController?.expandLoginButton()
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
            viewController?.expandLoginButton()
        }
    }
    
    func registrationButtonPressed() {
        print("registrationButtonPressed")
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
