
import Foundation
import FirebaseAuth

protocol EmailProviderable {
	func registerUser(
		with userRequest: RegisterUserRequest,
		completion: @escaping (Bool, Error?) -> Void
	)
	func loginUser(
		with userRequest: LoginUserRequest,
		completion: @escaping (Error?) -> Void
	)
}

final class EmailProvider {
	private let firestore: FirestoreServiceProtocol
	init(firestore: FirestoreServiceProtocol) {
		self.firestore = firestore
	}
}

extension EmailProvider: EmailProviderable {
	func registerUser(
		with userRequest: RegisterUserRequest,
		completion: @escaping (Bool, Error?) -> Void
	) {
		//        let username = userRequest.username
		let email = userRequest.email
		let password = userRequest.password
		
		Auth.auth().createUser(withEmail: email,
							   password: password) { result, error in
			if let error = error {
				completion(false, error)
				return
			} else {
				guard let userId = Auth.auth().currentUser?.uid else { return }
				self.firestore.addUserID(userID: userId)
				completion(true, nil)
			}
			guard let resultUser = result?.user else {
				completion(false, nil)
				return
			}
		}
	}
	
	func loginUser(
		with userRequest: LoginUserRequest,
		completion: @escaping (Error?) -> Void
	) {
		Auth.auth().signIn(withEmail: userRequest.email,
						   password: userRequest.password) { result, error in
			if let error = error {
				completion(error)
				return
			} else {
				guard let userId = Auth.auth().currentUser?.uid else { return }
				self.firestore.addUserID(userID: userId)
				completion(nil)
			}
		}
	}
}
