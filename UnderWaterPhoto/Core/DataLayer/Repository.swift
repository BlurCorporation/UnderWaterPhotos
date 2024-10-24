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
	/// Запрашивает данные со всех серверов, загружает и сохраняет,
		/// если такого контента ещё не было в локальной базе данных.
		/// - Parameter completion: возвращается после успешной загрузки каждой единицы контента.
		func updateContent(completion: @escaping () -> Void)
		/// Удаляет весь сохраненный контент из локальной базы данных.
		func deleteEntities()
		/// Осуществляет получение контента из локальной базы данных.
		/// - Returns: Массив контента.
		func getContent() -> [ContentModel]
		/// Осуществляет загрузку контента на сервер и сохранение в локальную базу данных
		/// - Parameters:
		///   - defaultImage: дефолтное изображение до обработки
		///   - processedImage: обработанное изображение
		///   - processedAlphaSetting: настройка прозрачности между обработанным и необработанным изображением
		///   - url: ссылка на обработанное видео из временного локального хранилища
		func addContent(
			defaultImage: UIImage?,
			processedImage: UIImage,
			processedAlphaSetting: Float?,
			processedVideoTempURL: String?
		)
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
							content.id = id.downloadid
							content.defaultid = nil
							content.alphaSetting = id.alphaSetting ?? .zero
							
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
							content.id = id.downloadid
							content.defaultid = id.defaultid
							content.alphaSetting = id.alphaSetting ?? .zero
							
							self.save()
							self.fileManager.saveContent(
								image: image,
								contentName: id.downloadid,
								url: nil,
								folderName: "ContentFolder"
							) { _ in
								guard let defaultid = id.defaultid else {
									completion()
									return
								}
								self.firebaseStorageManager.downloadImage(
									id: defaultid
								) { result in
									switch result {
									case .success(let image):
										self.fileManager.saveContent(
											image: image,
											contentName: defaultid,
											url: nil,
											folderName: "ContentFolder"
										) { _ in
											completion()
										}
									case .failure(let failure):
										print("Фото не скачалось")
									}
								}
							}
						}
					}
				case .failure:
					print("Фото не скачалось")
				}
			}
		}
	}
	
	private func uploadContent(
		defaultContentID: String?,
		processedContentID: String,
		alphaSetting: Float?
	) {
		guard let content = fileManager.getContent(
			imageName: processedContentID,
			defaultImageID: defaultContentID,
			alphaSetting: alphaSetting,
			folderName: "ContentFolder"
		) else {
			print("Error to get content in Repository")
			return
		}
		
		if let url = content.url {
			self.uploadVideo(
				url: url,
				image: content.image,
				processedContentID: processedContentID
			)
		} else {
			self.uploadImage(
				processedImage: content.image,
				processedImageID: processedContentID,
				defaultImage: content.defaultImage,
				defaultImageID: defaultContentID,
				alphaSetting: alphaSetting
			)
		}
	}
	
	private func uploadVideo(
		url: String,
		image: UIImage,
		processedContentID: String
	) {
		guard let url = URL(string: url) else { return }
		firebaseStorageManager.uploadVideo(url: url, id: processedContentID) { /*[weak self]*/ _ in
//				guard let self = self else { return }
//				switch result {
//				case .success:
//					break
//				case .failure:
//					break
//				}
		}
		firebaseStorageManager.uploadImage(
			image: image,
			id: processedContentID
		) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let id):
				self.setContentID(
					defaultContentID: nil,
					contentID: id,
					alphaSetting: nil
				)
			case .failure:
				break
			}
		}
	}
	
	private func uploadImage(
		processedImage: UIImage,
		processedImageID: String,
		defaultImage: UIImage?,
		defaultImageID: String?,
		alphaSetting: Float?
	) {
		firebaseStorageManager.uploadImage(
			image: processedImage,
			id: processedImageID
		) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let id):
				guard let defaultImage = defaultImage,
					  let defaultid = defaultImageID
				else {
					break
				}
				self.firebaseStorageManager.uploadImage(
					image: defaultImage,
					id: defaultid
				) { result in
					switch result {
					case .success(let defaultId):
						self.setContentID(
							defaultContentID: defaultId,
							contentID: id,
							alphaSetting: alphaSetting
						)
					case .failure:
						break
					}
				}
			case .failure:
				break
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
	
	private func setContentID(
		defaultContentID: String?,
		contentID: String,
		alphaSetting: Float?
	) {
		let contentModel = ContentFirestoreModel(
			defaultid: defaultContentID,
			downloadid: contentID,
			alphaSetting: alphaSetting
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
	
	// MARK: - Internal methods
	
}

// MARK: - RepositoryProtocol

extension Repository: RepositoryProtocol {
	func addContent(
		defaultImage: UIImage? = nil,
		processedImage: UIImage,
		processedAlphaSetting: Float? = nil,
		processedVideoTempURL: String? = nil
	) {
		let content = ContentEntity(context: coreDataManager.context)
		let id = UUID().uuidString
		content.id = id
		content.defaultid = id + "-default"
		content.alphaSetting = processedAlphaSetting ?? -1
		
		save()
		fileManager.saveContent(
			image: processedImage,
			contentName: id,
			url: processedVideoTempURL,
			folderName: "ContentFolder"
		) { [weak self] result in
			guard let self = self else { return }
			guard let defaultImage = defaultImage else {
				self.uploadContent(
					defaultContentID: nil,
					processedContentID: id,
					alphaSetting: nil
				)
				return
			}
			fileManager.saveContent(
				image: defaultImage,
				contentName: id + "-default",
				url: processedVideoTempURL,
				folderName: "ContentFolder") { result in
					self.uploadContent(
						defaultContentID: id + "-default",
						processedContentID: id,
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
			guard let id = i.id else { continue }
			if let savedContent = fileManager.getContent(
				imageName: id,
				defaultImageID: i.defaultid,
				alphaSetting: i.alphaSetting,
				folderName: "ContentFolder"
			) {
				if !images.contains(where: { model in
					
					model == savedContent
				}) {
					images.append(savedContent)
				}
			}
		}
		
		return images
	}
}
