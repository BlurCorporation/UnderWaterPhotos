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
    func registrationButtonPressed()
    func restorePasswordButtonPressed()
    func appleIdButtonPressed()
    func googleIdButtonPressed()
    func changeState(state: AuthState)
}

// MARK: - AuthPresenter

final class AuthPresenter {
    weak var viewController: AuthViewControllerProtocol?
    
    var state: AuthState = .registration
    
    //MARK: - PrivateProperties
    
    private let sceneBuildManager: Buildable
    private let authState: AuthState
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
    func changeState(state: AuthState) {
        self.state = state
    }
    
    func loginButtonPressed() {
        viewController?.expandLoginButton()
        switch state {
        case .login:
            authService.loginUser(with: <#T##LoginUserRequest?#>, typeAuth: <#T##TypeAuth#>, viewController: <#T##UIViewController?#>, completion: <#T##(Error?) -> Void#>)
        case .registration:
            break
        case .restore:
            break
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
