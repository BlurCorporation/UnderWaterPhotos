
import Foundation
import FirebaseAuth
import AuthenticationServices
import CryptoKit

protocol AppleProviderable {
	func handleAppleIdRequest(completion: @escaping (Error?) -> Void)
	func randomNonceString(length: Int) -> String
	func sha256(_ input: String) -> String
	
}

final class AppleProvider: NSObject {
	private var currentNonce: String?
	var completion: ((Error?) -> Void)?
}

extension AppleProvider: AppleProviderable {
	func handleAppleIdRequest(completion: @escaping (Error?) -> Void) {
		let nonce = randomNonceString()
		currentNonce = nonce
		let provider = ASAuthorizationAppleIDProvider()
		let request = provider.createRequest()
		request.requestedScopes = [.fullName,
								   .email]
		request.nonce = sha256(nonce)
		let controller = ASAuthorizationController(authorizationRequests: [request])
		controller.delegate = self
		controller.performRequests()
		self.completion = completion
	}
	
	internal func randomNonceString(length: Int = 32) -> String {
		precondition(length > 0)
		var randomBytes = [UInt8](repeating: 0,
								  count: length)
		let errorCode = SecRandomCopyBytes(kSecRandomDefault,
										   randomBytes.count,
										   &randomBytes)
		if errorCode != errSecSuccess {
			fatalError(
				"Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
			)
		}
		
		let charset: [Character] =
		Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
		
		let nonce = randomBytes.map { byte in
			charset[Int(byte) % charset.count]
		}
		
		return String(nonce)
	}
	
	@available(iOS 13, *)
	internal func sha256(_ input: String) -> String {
		let inputData = Data(input.utf8)
		let hashedData = SHA256.hash(data: inputData)
		let hashString = hashedData.compactMap {
			String(format: "%02x", $0)
		}.joined()
		
		return hashString
	}
}

extension AppleProvider: ASAuthorizationControllerDelegate {
	func authorizationController(
		controller: ASAuthorizationController,
		didCompleteWithError error: Error
	) {
		print("Sign in with Apple errored: \(error)")
		//TODO: - call error alert
	}
	
	func authorizationController(
		controller: ASAuthorizationController,
		didCompleteWithAuthorization authorization: ASAuthorization
	) {
		if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
			guard let nonce = currentNonce else {
				fatalError("Invalid state: A login callback was received, but no login request was sent.")
			}
			
			guard let appleIDToken = appleIDCredential.identityToken else {
				print("Unable to fetch identity token")
				return
			}
			guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
				print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
				return
			}
			let credential = OAuthProvider.credential(
				withProviderID: "apple.com",
				idToken: idTokenString,
				rawNonce: nonce
			)
			
			Auth.auth().signIn(
				with: credential
			) { (authResult, error) in
				if (error != nil) {
					print(error?.localizedDescription)
					return
				}
				
				let firstName = appleIDCredential.fullName?.familyName
				print(appleIDCredential.email)
				guard let completion = self.completion else { return }
				guard let userId = Auth.auth().currentUser?.uid else { return }
				completion(nil)
			}
		}
	}
}
