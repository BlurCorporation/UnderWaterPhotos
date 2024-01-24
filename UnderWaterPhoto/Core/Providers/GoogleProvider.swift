//
//  GoogleProvider.swift
//  ARHitBalls
//
//  Created by Максим Косников on 19.07.2023.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

protocol GoogleProviderable {
    func signIn(completion: @escaping (Error?) -> Void,
                viewController: UIViewController)
}

final class GoogleProvider {}

extension GoogleProvider: GoogleProviderable {
    func signIn(completion: @escaping (Error?) -> Void,
                viewController: UIViewController) {
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//        let config = GIDConfiguration(clientID: clientID)
//
//        GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController) { user, error in
//          guard error == nil else {
//              completion(error)
//            return
//          }
//
//          guard
//            let authentication = user?.authentication,
//            let idToken = authentication.idToken
//          else {
//            return
//          }
//
//          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
//                                                         accessToken: authentication.accessToken)
//
//            Auth.auth().signIn(with: credential) { result, error in
//                guard let userId = Auth.auth().currentUser?.uid else { return }
//                completion(nil)
//            }
//        }
    }
}
