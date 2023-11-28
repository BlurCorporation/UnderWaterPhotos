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
}

// MARK: - AuthPresenter

final class AuthPresenter {
    weak var viewController: AuthViewControllerProtocol?
    
    //MARK: - PrivateProperties
    
    private let sceneBuildManager: Buildable
    
    //MARK: - Initialize
    
    init(sceneBuildManager: Buildable) {
        self.sceneBuildManager = sceneBuildManager
    }
}

// MARK: - AuthPresenterProtocol Imp

extension AuthPresenter: AuthPresenterProtocol {
    func loginButtonPressed() {
        viewController?.expandLoginButton()
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
