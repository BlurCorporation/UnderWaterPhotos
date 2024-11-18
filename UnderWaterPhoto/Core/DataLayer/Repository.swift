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
	func updateContent(
		completion: @escaping ([ContentFirestoreModel]) -> Void
	)
	/// Удаляет весь сохраненный контент из локальной базы данных.
	func deleteLocalEntities()
	/// Удаляет весь сохраненный контент из облачной базы данных
	func deleteRemoteEntities()
	/// Осуществляет получение контента из локальной базы данных.
	/// - Returns: Массив контента.
	func getContent() -> [ContentModel]
	/// Осуществляет загрузку контента на сервер и сохранение в локальную базу данных
	/// - Parameters:
	///   - defaultImage: дефолтное изображение до обработки
	///   - processedImage: обработанное изображение
	///   - processedAlphaSetting: настройка прозрачности между обработанным и необработанным изображением
	///   - processedVideoTempURL: ссылка на обработанное видео из временного локального хранилища
	func addContent(
		defaultImage: UIImage?,
		processedImage: UIImage,
		processedAlphaSetting: Float?,
		processedVideoTempURL: String?
	)
	/// Скачиваем и сохраняем контент, если его ещё нет на устройстве.
	/// - Parameters:
	///   - firestoreModels: Массив моделей контента типа `ContentFirestoreModel`
	///   - completion: Возвращае модель типа `ContentFirestoreModel` после каждого сохранения
	func downloadAndSave(
		firestoreModels: [ContentFirestoreModel],
		completion: @escaping (ContentModel) -> Void
	)
	/// Проверяет, пуст ли кэш
	/// - Returns: булевое значение `true` если пуст и `false` если кэш есть
	func getIsCacheEmpty() -> Bool
	/// Удаляет контент из всех баз данных
	/// - Parameter contentModel: модель контента по которой берутся данные для удаления
	func deleteContent(contentModel: ContentModel)
}

class Repository {
	
	// MARK: - Dependencies
	
	private let fileManager: LocalFileManager
	private let coreDataManager: CoreDataManager
	private let firebaseStorageManager: FirebaseStorageManagerProtocol
	private let firestoreService: FirestoreServiceProtocol
	
	// MARK: - Private properties
	
	private var contentCoreData = [ContentEntity]()
	private var isCacheEmpty = false
	
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
	
	private func tryDownloadVideo(
		model: ContentFirestoreModel,
		processedImage: UIImage,
		completion: @escaping (ContentModel) -> Void
	) {
		// Пытаемся скачать видео из FirebaseStorage
		self.firebaseStorageManager.downloadVideo(id: model.downloadid) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let videoUrl):
				// Видео успешно скачалось, значит запускаем сценарий сохранения видео
				self.localSaveVideo(model: model, processedImage: processedImage, videoUrl: videoUrl, completion: completion)
			case .failure:
				// Видео не скачалось, значит запускаем сценарий сохранения изображения
				self.localSaveImage(model: model, processedImage: processedImage, completion: completion)
				break
			}
		}
	}
	
	private func localSaveVideo(
		model: ContentFirestoreModel,
		processedImage: UIImage,
		videoUrl: URL?,
		completion: @escaping (ContentModel) -> Void
	) {
		// Создаём сущность CoreData
		let content = ContentEntity(context: self.coreDataManager.context)
		content.id = model.downloadid
		content.defaultid = nil
		content.alphaSetting = model.alphaSetting ?? .zero
		// Сохраняем сущность
		self.save()
		// Сохраняем видео в LocalFileManager
		self.fileManager.saveContent(
			image: processedImage,
			contentName: model.downloadid,
			url: videoUrl?.absoluteString,
			folderName: "ContentFolder"
		) { [weak self] imageURL, videoURL in
			guard let _ = self else { return }
			let contentModel = ContentModel(
				id: model.downloadid,
				defaultid: model.defaultid,
				image: processedImage,
				url: videoURL.absoluteString
			)
			completion(contentModel)
		}
	}
	
	private func localSaveImage(
		model: ContentFirestoreModel,
		processedImage: UIImage,
		completion: @escaping (ContentModel) -> Void
	) {
		// Создаём сущность CoreData
		let content = ContentEntity(context: self.coreDataManager.context)
		content.id = model.downloadid
		content.defaultid = model.defaultid
		content.alphaSetting = model.alphaSetting ?? .zero
		// Сохраняем сущность
		self.save()
		// Сохраняем обработанное изображение в LocalFileManager
		self.fileManager.saveContent(
			image: processedImage,
			contentName: model.downloadid,
			url: nil,
			folderName: "ContentFolder"
		) { [weak self] _ in
			guard let self = self else { return }
			// Проверяем, есть id необработанного изображения
			guard let defaultid = model.defaultid else {
				// Вызываем callBack, обозначающий окончание флоу загрузки и сохранения
				completion(
					ContentModel(
						id: model.downloadid,
						defaultid: model.defaultid,
						alphaSetting: model.alphaSetting,
						image: processedImage
					)
				)
				return
			}
			// Скачиваем необработанное изображение из FirebaseStorage
			self.downloadDefaultImage(
				id: model.downloadid,
				defaultid: defaultid,
				completion: completion
			)
		}
	}
	
	private func downloadDefaultImage(
		id: String,
		defaultid: String,
		completion: @escaping (ContentModel) -> Void
	) {
		self.firebaseStorageManager.downloadImage(
			id: defaultid
		) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let image):
				self.fileManager.saveContent(
					image: image,
					contentName: defaultid,
					url: nil,
					folderName: "ContentFolder"
					) { _ in
						completion(
							ContentModel(
								id: id,
								defaultid: defaultid,
								image: image
							)
						)
					}
			case .failure(let error):
				print("Фото не скачалось \(error.localizedDescription)")
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
		
		guard let image = content.image else {
			print("content.image is nil in Repository")
			return
		}
		
		if let url = content.url {
			self.uploadVideo(
				url: url,
				image: image,
				processedContentID: processedContentID
			)
		} else {
			self.uploadImage(
				processedImage: image,
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
		firestoreService.setContentModel(
			contentModel: contentModel
		) { [weak self] result in
			guard let self = self else { return }
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
		defaultImage: UIImage?,
		processedImage: UIImage,
		processedAlphaSetting: Float?,
		processedVideoTempURL: String?
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
		) { [weak self] _ in
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
				folderName: "ContentFolder"
			) { [weak self] _ in
				guard let self = self else { return }
				self.uploadContent(
					defaultContentID: id + "-default",
					processedContentID: id,
					alphaSetting: processedAlphaSetting
				)
			}
		}
	}
	
	func updateContent(completion: @escaping ([ContentFirestoreModel]) -> Void) {
		firestoreService.getContentModel { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let contentsModel):
				guard let contentsModel = contentsModel else {
					print("нет данных")
					completion([])
					return
				}
				completion(contentsModel)
			case .failure:
				print("Ничего не скачалось с Firestore")
			}
		}
	}
	
	func deleteLocalEntities() {
		self.isCacheEmpty = true
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
	
	func deleteRemoteEntities() {
		self.firebaseStorageManager.deleteAllContent()
		self.firestoreService.deleteCollection()
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
	
	func getIsCacheEmpty() -> Bool {
		return self.isCacheEmpty
	}
	
	func deleteContent(contentModel: ContentModel) {
		// Удаление из локального хранилища
		self.fileManager.deleteImage(id: contentModel.id)
		if let defaultID = contentModel.defaultid {
			self.fileManager.deleteImage(id: defaultID)
		}
		if let _ = contentModel.url {
			self.fileManager.deleteVideo(id: contentModel.id)
		}
		// Удаление локальной базы данных
		self.getContentEntity()
		for content in contentCoreData {
			if content.id == contentModel.id {
				self.coreDataManager.delete(content)
				continue
			}
		}
		// Удаление из облачного хранилища
		self.firebaseStorageManager.deleteImage(id: contentModel.id)
		if let defaultID = contentModel.defaultid {
			self.firebaseStorageManager.deleteImage(id: defaultID)
		}
		if let _ = contentModel.url {
			self.firebaseStorageManager.deleteVideo(id: contentModel.id)
		}
		// Удаление из облачной базы данных
		self.firestoreService.deleteContentModel(
			id: contentModel.id,
			completion: { _ in }
		)
	}
	
	func downloadAndSave(
		firestoreModels: [ContentFirestoreModel],
		completion: @escaping (ContentModel) -> Void
	) {
		// Получаем массив id контента
		let contentIDs = self.getContent().map { $0.id }
		
		self.isCacheEmpty = firestoreModels.isEmpty
		
		for model in firestoreModels {
			guard !contentIDs.contains(model.downloadid) else { continue }
			// Скачиваем обработанное изображение из FirebaseStorage
			self.firebaseStorageManager.downloadImage(id: model.downloadid) { [weak self] result in
				guard let self = self else { return }
				switch result {
				case .success(let processedImage):
					self.tryDownloadVideo(model: model, processedImage: processedImage, completion: completion)
				case .failure:
					print("Фото не скачалось")
				}
			}
		}
	}
}
