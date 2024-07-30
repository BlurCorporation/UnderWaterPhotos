//
//  FirestoreService.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 16.07.2024.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct ContentFirestoreModel: Codable {
	let downloadid: String
}

protocol FirestoreServiceProtocol {
	func setContentID(
		contentModel: ContentFirestoreModel,
		completion: @escaping (Result<Bool, Error>) -> Void
	)
	
	func getContentID(
		completion: @escaping (Result<[ContentFirestoreModel]?, Error>) -> Void
	)
	
	func deleteContentID(
		contentID: ContentFirestoreModel,
		completion: @escaping (Result<Bool, Error>) -> Void
	)
	
	func addUserID(userID: String)
}

final class FirestoreService {
	var uid: String?
	static let shared = FirestoreService()
	func configureFB() -> Firestore {
		var database: Firestore
		let settings = FirestoreSettings()
		Firestore.firestore().settings = settings
		database = Firestore.firestore()
		return database
	}
	
	// MARK: - Private Properties
	
	private func oneCalculation(from calcDict: [String: Any]) -> ContentFirestoreModel {
		let decoder = JSONDecoder()
		
		var model = ContentFirestoreModel(downloadid: "")
		
		do {
			let jsonData = try JSONSerialization.data(
				withJSONObject: calcDict,
				options: JSONSerialization.WritingOptions.prettyPrinted
			)
			model = try decoder.decode(
				ContentFirestoreModel.self,
				from: jsonData
			)
		} catch {
			print("Error", error)
		}
		return model
	}
}

extension FirestoreService: FirestoreServiceProtocol {
	func setContentID(
		contentModel: ContentFirestoreModel,
		completion: @escaping (Result<Bool, Error>) -> Void
	) {
		guard let uid = self.uid else {
			print("FirestoreService: userid identify error")
			return
		}
		let db = configureFB()
		let contentRef = db.collection("users").document(uid).collection("content")
		do {
			try contentRef.addDocument(from: contentModel) { error in
				if let error = error {
					print("FirestoreService setCalculation: Error writing document: \(error)")
					completion(.failure(error))
				} else {
					print("FirestoreService setCalculation: Document successfully written!")
					completion(.success(true))
				}
			}
		} catch let error {
			print("FirestoreService setContent: Error writing to Firestore: \(error)")
			completion(.failure(error))
		}
	}
	
	func getContentID(
		completion: @escaping (Result<[ContentFirestoreModel]?, Error>) -> Void
	) {
		guard let uid = self.uid else {
			print("FirestoreService: userid identify error")
			return
		}
		let db = configureFB()
		let contentRef = db.collection("users").document(uid).collection("content")
		contentRef.getDocuments { querySnapshot, error in
			guard let querySnapshot = querySnapshot else {
				print("ERROR getAllCalculations querySnapshot")
				completion(.success(nil))
				return
			}
			if let error = error {
				print("Error getting documents: \(error)")
				completion(.failure(error))
			} else {
				let model = querySnapshot.documents.map({self.oneCalculation(from: $0.data())})
				completion(.success(model))
			}
		}
	}
	
	func deleteContentID(
		contentID: ContentFirestoreModel,
		completion: @escaping (Result<Bool, Error>) -> Void
	) {
		
	}
	
	func addUserID(userID: String) {
		self.uid = userID
	}
}

