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
		contentID: String,
		alphaSetting: Float?
	)
	func getContentID()
	func updateContent(completion: @escaping () -> Void)
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
	}
	
	// MARK: - Private methods
	
	private func downloadAndSave(
		contentIDs: [ContentFirestoreModel],
		completion: @escaping () -> Void
	) {
		let contents = self.getContent().map { $0.id }
		print("CONTENTIDS")
		
		for id in contentIDs {
			guard !contents.contains(id.downloadid) else { continue }
			self.firebaseStorageManager.downloadImage(id: id.downloadid) { [weak self] result in
				guard let self = self else { return }
				switch result {
				case .success(let image):
					self.firebaseStorageManager.downloadVideo(id: id.downloadid) { result in
						switch result {
						case .success(let videoUrl):
							let content = ContentEntity(context: self.coreDataManager.context)
							content.id = UUID(uuidString: id.downloadid)
							
							self.save()
							self.fileManager.saveContent(
								image: image,
								contentName: id.downloadid,
								url: videoUrl?.absoluteString,
								folderName: "ContentFolder"
							) { _ in
								completion()
							}
						case .failure:
							let content = ContentEntity(context: self.coreDataManager.context)
							content.id = UUID(uuidString: id.downloadid)
							
							self.save()
							self.fileManager.saveContent(
								image: image,
								contentName: id.downloadid,
								url: nil,
								folderName: "ContentFolder"
							) { _ in
								completion()
							}
						}
					}
				case .failure:
					print("видео не скачалось")
				}
			}
		}
	}
	
	private func uploadContent(
		id: String,
		alphaSetting: Float?
	) {
		guard let content = fileManager.getContent(imageName: id, folderName: "ContentFolder") else {
			print("Error to get content in Repository")
			return
		}
		
		if let url = content.url {
			guard let url = URL(string: url) else { return }
			firebaseStorageManager.uploadVideo(url: url, id: id) { result in
				switch result {
				case .success(let id):
					break
				case .failure:
					break
				}
			}
			firebaseStorageManager.uploadImage(
				image: content.image,
				id: id
			) { result in
				switch result {
				case .success(let id):
					self.setContentID(
						contentID: id,
						alphaSetting: nil
					)
				case .failure:
					break
				}
			}
		} else {
			firebaseStorageManager.uploadImage(
				image: content.image,
				id: id
			) { result in
				switch result {
				case .success(let id):
					self.setContentID(
						contentID: id,
						alphaSetting: alphaSetting
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
	
	func addContent(
		defaultImage: UIImage? = nil,
		processedImage: UIImage,
		processedAlphaSetting: Float? = nil,
		url: String? = nil
	) {
		let content = ContentEntity(context: coreDataManager.context)
		let id = UUID()
		content.id = id
		
		save()
		fileManager.saveContent(
			image: processedImage,
			contentName: id.uuidString,
			url: url,
			folderName: "ContentFolder"
		) { [weak self] result in
			guard let self = self else { return }
			self.uploadContent(
				id: id.uuidString,
				alphaSetting: nil
			)
			guard let defaultImage = defaultImage else { return }
			fileManager.saveContent(
				image: defaultImage,
				contentName: id.uuidString + "-default",
				url: url,
				folderName: "ContentFolder") { result in
					self.uploadContent(
						id: id.uuidString + "-default",
						alphaSetting: processedAlphaSetting
					)
				}
		}
	}
	
	func updateContent(completion: @escaping () -> Void) {
		firestoreService.getContentID { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let contentsModel):
				guard let contentsModel = contentsModel else {
					print("нет данных")
					return
				}
				self.downloadAndSave(contentIDs: contentsModel) {
					completion()
				}
			case .failure:
				print("Ничего не скачалось с Firestore")
			}
		}
	}
}

// MARK: - RepositoryProtocol

extension Repository: RepositoryProtocol {
	func setContentID(
		contentID: String,
		alphaSetting: Float?
	) {
		let contentModel = ContentFirestoreModel(
			downloadid: contentID,
			alphaSetting: alphaSetting ?? .zero
		)
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
