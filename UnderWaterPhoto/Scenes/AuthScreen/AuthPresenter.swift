//
//  AuthPresenter.swift
//  UnderWaterPhoto
//
//  Created by Антон on 20.09.2023.
//
import UIKit
import FirebaseAuth

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
	func changeAuthState(authState: AuthState)
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
	
	func changeAuthState(authState: AuthState) {
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
		self.defaultsManager.saveObject(name, for: .userName)
		self.defaultsManager.saveObject(email, for: .email)
		switch authState {
		case .registration:
			guard !name.isEmpty,
				  !email.isEmpty,
				  !password.isEmpty,
				  !repeatPassword.isEmpty
			else {
				showErrorAlert(error: .textFieldIsEmpty)
				return
			}
			guard password == repeatPassword else {
				showErrorAlert(error: .repeatPasswordInvalid)
				return
			}
			self.makeRegistrationRequest(
				name: name,
				email: email,
				password: password
			)
		case .login:
			guard !email.isEmpty, !password.isEmpty else {
				showErrorAlert(error: .textFieldIsEmpty)
				return
			}
			self.makeLoginRequest(
				email: email,
				password: password
			)
		case .restore:
			guard !email.isEmpty else {
				showErrorAlert(error: .textFieldIsEmpty)
				return
			}
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
				self.showErrorAlert(error: .firebaseAuthError(error as! AuthErrorCode))
			}
			if isSuccessRegister {
				self.defaultsManager.saveObject(isSuccessRegister,for: .isUserAuth)
				let viewController = self.sceneBuildManager.buildMainView()
				self.viewController?.navigationController?.pushViewController(viewController, animated: true)
			} else {
				self.showErrorAlert(error: .somethingWrong)
			}
		}
	}
	
	private func makeLoginRequest(
		email: String,
		password: String
	) {
		self.defaultsManager.saveObject(email, for: .email)
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
				self.showErrorAlert(error: .firebaseAuthError(error as! AuthErrorCode))
			}
			self.defaultsManager.saveObject(true, for: .isUserAuth)
			let viewController = self.sceneBuildManager.buildMainView()
			self.viewController?.navigationController?.pushViewController(viewController, animated: true)
		}
		
	}
	
	private func makeRestoreRequest(email: String) {}
	
	private func showErrorAlert(error: AuthModel.Error) {
		
		let message: String = {
			switch error {
			case .firebaseAuthError(let authErrorCode):
				switch authErrorCode.code {
				case .invalidCredential:
					return L10n.AuthVC.Error.InvalidCredential.message
				case .userDisabled:
					return L10n.AuthVC.Error.UserDisabled.message
				case .emailAlreadyInUse:
					return L10n.AuthVC.Error.EmailAlreadyInUse.message
				case .invalidEmail:
					return L10n.AuthVC.Error.InvalidEmail.message
				case .weakPassword:
					return L10n.AuthVC.Error.WeakPassword.message
				default:
					return L10n.AuthVC.Error.SomethingWrong.message
				}
			case .repeatPasswordInvalid:
				return L10n.AuthVC.Error.RepeatPasswordInvalid.message
			case .textFieldIsEmpty:
				return L10n.AuthVC.Error.TextFieldIsEmpty.message
			case .somethingWrong:
				return L10n.AuthVC.Error.SomethingWrong.message
			}
		}()
		
		self.viewController?.showErrorAlert(with: message)
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
