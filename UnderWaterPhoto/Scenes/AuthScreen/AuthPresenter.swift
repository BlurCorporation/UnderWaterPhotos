//
//  AuthPresenter.swift
//  UnderWaterPhoto
//
//  Created by Антон on 20.09.2023.
//
import UIKit

// MARK: - AuthPresenterProtocol

protocol AuthPresenterProtocol: AnyObject {
	func changeAuthTypeButtonPressed()
	func signInButtonTap(
		email: String,
		name: String,
		password: String,
		repeatPassword: String
	)
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
	
	func changeAuthTypeButtonPressed() {
		self.authState = .login
		viewController?.expandLoginButton()
	}
	
	func signInButtonTap(
		email: String,
		name: String = "",
		password: String = "",
		repeatPassword: String = ""
	) {
		
		switch authState {
		case .registration:
			guard !name.isEmpty,
				  !email.isEmpty,
				  !password.isEmpty,
				  !repeatPassword.isEmpty,
				  password == repeatPassword else { return }
			self.makeRegistrationRequest(
				name: name,
				email: email,
				password: password
			)
		case .login:
			guard !email.isEmpty, !password.isEmpty else { return }
			self.makeLoginRequest(
				email: email,
				password: password
			)
		case .restore:
			guard !email.isEmpty else { return }
			self.makeRestoreRequest(email: email)
		}
	}
	private func makeRegistrationRequest(
		name: String,
		email: String,
		password: String
	) {
		let newUser = RegisterUserRequest(
			name: name,
			email: email,
			password: password
		)
		self.authService.registerUser(with: newUser) { isSuccessRegister, error in
			if let error = error {
				self.showError(error: error)
			}
			if isSuccessRegister {
				self.defaultsManager.saveObject(isSuccessRegister,for: .isUserAuth)
				let viewController = self.sceneBuildManager.buildMainView()
				self.viewController?.navigationController?.pushViewController(viewController, animated: true)
			} else {
				// обработка ошибки если потребуется
			}
		}
	}
	
	private func makeLoginRequest(
		email: String,
		password: String
	) {
		let user = LoginUserRequest(
			email: email,
			password: password
		)
		
		authService.loginUser(
			with: user,
			typeAuth: .email,
			viewController: nil
		) { error in
			if let error = error {
				self.showError(error: error)
			}
			self.defaultsManager.saveObject(true, for: .isUserAuth)
			let viewController = self.sceneBuildManager.buildMainView()
			self.viewController?.navigationController?.pushViewController(viewController, animated: true)
		}
		
	}
	
	private func makeRestoreRequest(email: String) {}
	
	private func showError(error: Error) {
		print(error.localizedDescription)
		let alertController = UIAlertController(
			title: "Ошибка",
			message: error.localizedDescription,
			preferredStyle: .alert
		)
		let okAction = UIAlertAction(
			title: "OK",
			style: .default,
			handler: nil
		)
		alertController.addAction(okAction)
		self.viewController?.present(
			alertController,
			animated: true,
			completion: nil
		)
	}
	
	func restorePasswordButtonPressed() {
		self.authState = .restore
		viewController?.restorePasswordExpand()
	}
	
	func appleIdButtonPressed() {
		print("appleIdButtonAPressed")
	}
	
	func googleIdButtonPressed() {
		print("googleIdButtonPressed")
	}
}
