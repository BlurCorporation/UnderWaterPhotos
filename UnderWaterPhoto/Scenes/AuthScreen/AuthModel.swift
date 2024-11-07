//
//  AuthModel.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 07.11.2024.
//

import Foundation
import FirebaseAuth

enum AuthModel {
	enum Error {
		case firebaseAuthError(AuthErrorCode)
		case repeatPasswordInvalid
		case textFieldIsEmpty
		case somethingWrong
	}
}
