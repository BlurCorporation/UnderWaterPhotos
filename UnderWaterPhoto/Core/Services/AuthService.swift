
import UIKit
import FirebaseAuth

enum TypeAuth {
	case email
	case google
	case apple
}

protocol AuthServicable {
	func isAuth() -> Bool
	func getUserName() -> String
	func loginUser(with userRequest: LoginUserRequest?,
				   typeAuth: TypeAuth,
				   viewController: UIViewController?,
				   completion: @escaping (Error?) -> Void)
	func registerUser(with userRequest: RegisterUserRequest?,
					  completion: @escaping (Bool, Error?) -> Void)
	func logout(completion: @escaping ((Result<Void, Error>)) -> Void)
	func userAuthed()
	func deleteUser(completion: @escaping (Result<Void, Error>) -> Void)
}

final class AuthService {
	private let eMailProvider: EmailProviderable
	private let appleProvider: AppleProviderable
	private let googleProvider: GoogleProviderable
	private let defaultsManager: DefaultsManagerable
	
	init(
		defaultsManager: DefaultsManagerable,
		firestoreService: FirestoreServiceProtocol
	) {
		self.eMailProvider = EmailProvider(firestore: firestoreService)
		self.appleProvider = AppleProvider()
		self.googleProvider = GoogleProvider()
		self.defaultsManager = defaultsManager
		guard let uid = Auth.auth().currentUser?.uid else {
			print("AuthService: currentUser doesnt exist")
			return
		}
		firestoreService.addUserID(userID: uid)
	}
}

extension AuthService: AuthServicable {
	func userAuthed() {
		defaultsManager.saveObject(true, for: .isUserAuth)
		
	}
	
	func getUserName() -> String {
		guard let userId = Auth.auth().currentUser?.displayName else { return "" }
		return userId
	}
	
	
	func isAuth() -> Bool {
		guard let userId = Auth.auth().currentUser?.uid else { return false }
		return true
	}
	
	func loginUser(
		with userRequest: LoginUserRequest?,
		typeAuth: TypeAuth,
		viewController: UIViewController?,
		completion: @escaping (Error?) -> Void
	) {
		switch typeAuth {
		case .email:
			guard let userRequest = userRequest else { return }
			eMailProvider.loginUser(
				with: userRequest,
				completion: completion
			)
		case .google:
			guard let viewController = viewController else { return }
			googleProvider.signIn(
				completion: completion,
				viewController: viewController
			)
		case .apple:
			appleProvider.handleAppleIdRequest(completion: completion)
		}
	}
	
	func registerUser(
		with userRequest: RegisterUserRequest?,
		completion: @escaping (Bool, Error?) -> Void
	) {
		guard let userRequest = userRequest else { return }
		self.eMailProvider.registerUser(
			with: userRequest,
			completion: completion
		)
	}
	
	func logout(
		completion: @escaping (Result<Void, Error>) -> Void
	) {
		do {
			try Auth.auth().signOut()
			defaultsManager.saveObject(false, for: .isUserAuth)
			completion(.success(Void()))
		} catch let error {
			completion(.failure(error))
		}
		self.defaultsManager.saveObject(false, for: .isUserAuth)
	}
	
	func deleteUser(
		completion: @escaping (Result<Void, Error>) -> Void
	) {
		let user = Auth.auth().currentUser
		
		user?.delete { error in
			if let error = error {
				completion(.failure(error))
			} else {
				completion(.success(Void()))
			}
		}
	}
}
