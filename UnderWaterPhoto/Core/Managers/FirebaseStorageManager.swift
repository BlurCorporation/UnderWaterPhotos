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

protocol FirebaseStorageManagerProtocol {
	func uploadFile(
		url: URL,
		id: String
	)
	func uploadTOFireBaseVideo(
		url: URL,
		success : @escaping (String) -> Void,
		failure : @escaping (Error) -> Void
	)
}

final class FirebaseStorageManager {
	
	// MARK: - Private properties
	
	private let storage: Storage
	private let storageRef: StorageReference
	
	// MARK: - Lifecycle
	
	init() {
		self.storage = Storage.storage()
		self.storageRef = self.storage.reference()
	}
}

// MARK: - FirebaseStorageManagerProtocol

extension FirebaseStorageManager: FirebaseStorageManagerProtocol {
	func uploadFile(
		url: URL,
		id: String
	) {
		// File located on disk
		
		// Create a reference to the file you want to upload
		let riversRef = storageRef.child("\(id).m4v")

		// Upload the file to the path "images/rivers.jpg"
		let uploadTask = riversRef.putFile(from: url, metadata: nil) { metadata, error in
			guard let metadata = metadata else {
				// Uh-oh, an error occurred!
				print(error?.localizedDescription)
				return
			}
			// Metadata contains file metadata such as size, content-type.
			let size = metadata.size
			// You can also access to download URL after upload.
//			riversRef.downloadURL { (url, error) in
//				guard let downloadURL = url else {
//					// Uh-oh, an error occurred!
//					return
//				}
//			}
		}
		
		uploadTask.observe(.progress) { snapshot in
			let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
			   / Double(snapshot.progress!.totalUnitCount)
			print(percentComplete)
		}
		
	}
	
//	func uploadFile(url: URL) {
//		do {
//			let videoData = try Data(contentsOf: url)
//			storageRef.child("images/rivers.m4v").putData(videoData) { metadata, error in
//				guard let metadata = metadata else {
//					// Uh-oh, an error occurred!
//					print(error?.localizedDescription)
//					return
//				}
//				print("success")
//			}
//			
//		} catch {
//			print(error.localizedDescription)
//		}
//	}
	
	func uploadTOFireBaseVideo(
		url: URL,
		success : @escaping (String) -> Void,
		failure : @escaping (Error) -> Void
	) {
		
		let name = "\(Int(Date().timeIntervalSince1970)).mp4"
		let path = NSTemporaryDirectory() + name
		
//		let dispatchgroup = DispatchGroup()
		
//		dispatchgroup.enter()
		
		let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
		let outputurl = documentsURL.appendingPathComponent(name)
		var ur = outputurl
//		self.convertVideo(toMPEG4FormatForVideo: url as URL, outputURL: outputurl) { (session) in
//			
//			ur = session.outputURL!
//			dispatchgroup.leave()
//			
//		}
//		dispatchgroup.wait()
		
		let data = NSData(contentsOf: url as URL)
		
		do {
			
			try data?.write(to: url, options: .atomic)
			
		} catch {
			
			print(error)
		}
		
		let storageRef = Storage.storage().reference().child("Videos").child(name)
		if let uploadData = data as Data? {
			storageRef.putData(uploadData) { NSMetadata, error in
				if let error = error {
					failure(error)
				} else{
					success("success")
				}
				
			}
		}
	}
}

