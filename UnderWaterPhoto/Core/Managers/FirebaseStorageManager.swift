//
//  FirebaseStorageManager.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 30.06.2024.
//

import Foundation
import FirebaseCore
import FirebaseStorage
import AVFoundation

enum FirebaseStorageError: Error {
	case invalidURL
	case error(Error)
}

protocol FirebaseStorageManagerProtocol {
	func uploadVideo(
		url: URL,
		id: String,
		completion: @escaping (Result<String, FirebaseStorageError>) -> Void
	)
	
	func uploadImage(
		image: UIImage,
		id: String,
		completion: @escaping (Result<String, FirebaseStorageError>) -> Void
	)
	
	func downloadImage(
		id: String,
		completion: @escaping (Result<UIImage, Error>) -> Void
	)
	
	func downloadVideo(
		id: String,
		completion: @escaping (Result<URL?, Error>) -> Void
	)
}

final class FirebaseStorageManager {
	
	// MARK: - Dependencies
	
	private let authService: AuthServicable
	
	// MARK: - Private properties
	
	private let storage: Storage
	private let storageRef: StorageReference
	
	// MARK: - Lifecycle
	
	init(authService: AuthServicable) {
		self.storage = Storage.storage()
		self.storageRef = self.storage.reference()
		self.authService = authService
	}
}

// MARK: - FirebaseStorageManagerProtocol

extension FirebaseStorageManager: FirebaseStorageManagerProtocol {
	func uploadVideo(
		url: URL,
		id: String,
		completion: @escaping (Result<String, FirebaseStorageError>) -> Void
	) {
		let folderID = authService.getUserName()
		let ref = storageRef.child("\(folderID)/\(id).m4v")
		
		let uploadTask = ref.putFile(from: url, metadata: nil) { metadata, error in
			guard let _ = metadata else {
				print(error?.localizedDescription as Any)
				return
			}
		}
		
		uploadTask.observe(.progress) { snapshot in
			let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
			/ Double(snapshot.progress!.totalUnitCount)
			print(percentComplete)
		}
		
		uploadTask.observe(.success) { _ in
			completion(.success(id))
		}
	}
	
	func uploadImage(
		image: UIImage,
		id: String,
		completion: @escaping (Result<String, FirebaseStorageError>) -> Void
	) {
		guard let data = image.pngData() else { return }
		let folderID = authService.getUserName()
		let ref = storageRef.child("\(folderID)/\(id).png")
		
		let uploadTask = ref.putData(data) { metadata, error in
			guard let _ = metadata else {
				print(error?.localizedDescription as Any)
				return
			}
		}
		
		uploadTask.observe(.progress) { snapshot in
			let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
			/ Double(snapshot.progress!.totalUnitCount)
			print(percentComplete)
		}
		
		uploadTask.observe(.success) { _ in
			completion(.success(id))
		}
	}
	
	func downloadImage(
		id: String,
		completion: @escaping (Result<UIImage, Error>) -> Void
	) {
		let ref = storageRef.child(id + ".png")
		let _ = ref.getData(maxSize: Int64.max) { data, error in
			if let error = error {
				completion(.failure(error))
			} else {
				let image = UIImage(data: data!)
				completion(.success(image!))
			}
		}
	}
	
	func downloadVideo(
		id: String,
		completion: @escaping (Result<URL?, Error>) -> Void
	) {
		let ref = storageRef.child(id + ".m4v")
		let directory = NSTemporaryDirectory()
		let fileName = NSUUID().uuidString
		let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName])
		let _ = ref.write(toFile: fullURL!) { url, error in
			if let error = error {
				completion(.failure(error))
			} else {
				completion(.success(url))
			}
		}
	}
}
