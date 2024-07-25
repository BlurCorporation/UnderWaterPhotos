//
//  Repository.swift
//  UnderWaterPhoto
//
//  Created by USER on 14.12.2023.
//

import Foundation
import CoreData
import UIKit
import FirebaseFirestore

protocol RepositoryProtocol {
	func setContentID(
		contentID: String
	)
	func getContentID()
}

class Repository {
	
	// MARK: - Dependencies
	
	private let fileManager: LocalFileManager
	private let coreDataManager: CoreDataManager
	private let firebaseStorageManager: FirebaseStorageManagerProtocol
	private let firestoreService: FirestoreServiceProtocol
	
	// MARK: - Private properties
	
	private var contentCoreData = [ContentEntity]()
	
	// MARK: - Lifecycle
	
	init(
		firebaseStorageManager: FirebaseStorageManagerProtocol,
		firestoreService: FirestoreServiceProtocol
	) {
		self.fileManager = LocalFileManager.instance
		self.coreDataManager = CoreDataManager.shared
		self.firebaseStorageManager = firebaseStorageManager
		self.firestoreService = firestoreService
		
		firestoreService.getContentID { result in
			switch result {
			case .success(let contentsModel):
				guard let contentsModel = contentsModel else {
					print("нет данных")
					return
				}
				self.downloadAndSave(contentIDs: contentsModel)
			case .failure:
				print("Ничего не скачалось с Firestore")
			}
		}
	}
	
	// MARK: - Private methods
	
	private func downloadAndSave(contentIDs: [ContentFirestoreModel]) {
		let contents = self.getContent().map { $0.id.uuidString }
		for id in contentIDs {
			guard !contents.contains(id.downloadurl) else { continue }
			self.firebaseStorageManager.downloadImage(id: id.downloadurl) { [weak self] result in
				guard let self = self else { return }
				switch result {
				case .success(let image):
					self.firebaseStorageManager.downloadVideo(id: id.downloadurl) { result in
						switch result {
						case .success(let videoUrl):
							let content = ContentEntity(context: self.coreDataManager.context)

							content.id = UUID(uuidString: id.downloadurl)
							
							self.save()
							self.fileManager.saveContent(
								image: image,
								contentName: id.downloadurl,
								url: videoUrl?.absoluteString,
								folderName: "ContentFolder"
							) { _ in
							}
						case .failure:
							let content = ContentEntity(context: self.coreDataManager.context)

							content.id = UUID(uuidString: id.downloadurl)
							
							self.save()
							self.fileManager.saveContent(
								image: image,
								contentName: id.downloadurl,
								url: nil,
								folderName: "ContentFolder"
							) { _ in
							}
						}
					}
				case .failure:
					print("видео не скачалось")
				}
			}
		}
	}
	
	private func uploadContent(id: UUID) {
		let stringID = id.uuidString
		guard let content = fileManager.getContent(imageName: stringID, folderName: "ContentFolder") else {
			print("Error to get content in Repository")
			return
		}
		
		if let url = content.url {
			guard let url = URL(string: url) else { return }
			firebaseStorageManager.uploadVideo(url: url, id: stringID) { result in
				switch result {
				case .success(let id):
//					self.setContentID(
//						contentID: stringID,
//						downloadurl: url
//					)
					break
				case .failure:
					break
				}
			}
			firebaseStorageManager.uploadImage(
				image: content.image,
				id: stringID
			) { result in
				switch result {
				case .success(let id):
					self.setContentID(
						contentID: id
					)
				case .failure:
					break
				}
			}
		} else {
			firebaseStorageManager.uploadImage(
				image: content.image,
				id: stringID
			) { result in
				switch result {
				case .success(let id):
					self.setContentID(
						contentID: id
					)
				case .failure:
					break
				}
			}
		}
	}
	
	private func save() {
		contentCoreData.removeAll()
		coreDataManager.save()
	}
	
	private func getContentEntity() {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ContentEntity")
		do {
			contentCoreData = try coreDataManager.context.fetch(request) as [ContentEntity]
		} catch let error {
			print("Error fetching entity: \(error.localizedDescription)")
		}
	}
	
	// MARK: - Internal methods
	
	func deleteEntities() {
		let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ContentEntity")
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
		do {
			try coreDataManager.context.execute(deleteRequest)
			try coreDataManager.context.save()
			fileManager.deleteCache(folderName: "ContentFolder")
		} catch {
			print ("There was an error")
		}
	}
	
	func getContent() -> [ContentModel] {
		getContentEntity()
		var images = [ContentModel]()
		
		for i in contentCoreData {
			let id = (i.id?.uuidString)!
			if let savedContent = fileManager.getContent(imageName: id, folderName: "ContentFolder") {
				if !images.contains(where: { model in
					model == savedContent
				}) {
					images.append(savedContent)
				}
			}
		}
		
		return images
	}
	
	func addContent(uiimage: UIImage, url: String? = nil) {
		let content = ContentEntity(context: coreDataManager.context)
		let id = UUID()
		content.id = id
		
		save()
		fileManager.saveContent(
			image: uiimage,
			contentName: id.uuidString,
			url: url,
			folderName: "ContentFolder"
		) { result in
			if true {
				uploadContent(id: id)
			}
		}
	}
}

// MARK: - RepositoryProtocol

extension Repository: RepositoryProtocol {
	func setContentID(
		contentID: String
	) {
		let contentModel = ContentFirestoreModel(downloadurl: contentID)
		firestoreService.setContentID(
			contentModel: contentModel
		) { result in
			switch result {
			case .success(let success):
				print(success)
			case .failure:
				break
			}
		}
	}
	
	func getContentID() {
		
	}
}
