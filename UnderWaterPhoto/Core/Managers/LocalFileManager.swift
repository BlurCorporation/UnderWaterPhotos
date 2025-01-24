//
//  LocalFileManager.swift
//  UnderWaterPhoto
//
//  Created by USER on 14.12.2023.
//

import Foundation
import UIKit

class LocalFileManager {
	static let instance = LocalFileManager()
	
	private init() { }
	
	func saveContent(
		image: UIImage,
		contentName: String,
		url: String?,
		folderName: String,
		completion: @escaping ((imageURL: URL, videoURL: URL)) -> Void
	) {
		createFolderIfNeeded(folderName: folderName)
		
		DispatchQueue.global().async { [weak self] in
			guard let self = self else { return }
			guard
				let data = image.pngData(),
				let imageURL = self.getURLForImage(imageName: contentName, folderName: folderName)
			else { return }
			
			do {
				if let _url = url {
					// удаляем ранее созданный временный файл
					try FileManager.default.copyItem(
						at: URL(string: _url)!,
						to: getURLForVideo(videoName: contentName, folderName: "ContentFolder")!
					)
					try FileManager.default.removeItem(at: URL(string: _url)!)
				}
			} catch {
				print("Error copying")
			}
			
			do {
				try data.write(to: imageURL)
			} catch let error {
				print("Error saving image. ImageName: \(contentName) \(error)")
			}
			completion((imageURL, getURLForVideo(videoName: contentName, folderName: "ContentFolder")!))
		}
	}
	
	func getContent(
		imageName: String,
		defaultImageID: String?,
		alphaSetting: Float?,
		folderName: String
	) -> ContentModel? {
		guard
			let processedImageURL = getURLForImage(imageName: imageName, folderName: folderName),
				FileManager.default.fileExists(atPath: processedImageURL.path) else {
			return nil
		}
		
		var videoURL: URL? = getURLForVideo(videoName: imageName, folderName: folderName)
		
		do {
			_ = try FileManager.default.attributesOfItem(atPath: videoURL!.path)[.size] as? UInt64
		} catch {
			videoURL = nil
		}
		
		guard
			let image = UIImage(contentsOfFile: processedImageURL.path)
		else {
			return nil
		}
		
		if let defaultImageID = defaultImageID,
		   let defaultImageURL = getURLForImage(imageName: defaultImageID, folderName: folderName) {
			let defaultImage = UIImage(contentsOfFile: defaultImageURL.path)
			return ContentModel(
				id: imageName,
				defaultid: defaultImageID,
				defaultImage: defaultImage,
				alphaSetting: alphaSetting,
				image: image,
				url: videoURL?.absoluteString
			)
		}
		
		return ContentModel(id: imageName, image: image, url: videoURL?.absoluteString)
	}
	
	func deleteImage(id: String) {
		guard let imageURL = getURLForImage(imageName: id, folderName: "ContentFolder"),
			  FileManager.default.fileExists(atPath: imageURL.path)
		else {
			print("Ошибка чтения фото при удалении\nid: \(id)")
			return
		}
		
		do {
			try FileManager.default.removeItem(at: imageURL)
		} catch {
			print("Ошибка удаления фото\nid: \(id)")
		}
	}
	
	func deleteVideo(id: String) {
		guard let videoURL = getURLForVideo(videoName: id, folderName: "ContentFolder"),
			  FileManager.default.fileExists(atPath: videoURL.path)
		else {
			print("Ошибка чтения видео при удалении\nid: \(id)")
			return
		}
		do {
			try FileManager.default.removeItem(at: videoURL)
		} catch {
			print("Ошибка удаления видео\nid: \(id)")
		}
	}
	
	func getVideo(videoId: String) -> ContentModel? {
		guard
			let processedImageURL = getURLForImage(imageName: videoId, folderName: "ContentFolder"),
				FileManager.default.fileExists(atPath: processedImageURL.path) else {
			return nil
		}
		let videoURL: URL? = getURLForVideo(videoName: videoId, folderName: "ContentFolder")
		do {
			_ = try FileManager.default.attributesOfItem(atPath: videoURL!.path)[.size] as? UInt64
		} catch {
			print("Error in getVideo LocalFileManager")
			return nil
		}
		guard
			let image = UIImage(contentsOfFile: processedImageURL.path)
		else {
			return nil
		}
		
		return ContentModel(
			id: videoId,
			image: image,
			url: videoURL?.absoluteString
		)
	}
	
	
	private func createFolderIfNeeded(folderName: String) {
		guard let url = getURLForFolder(folderName: folderName) else { return }
		if !FileManager.default.fileExists(atPath: url.path) {
			do {
				try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
			} catch let error {
				print("Error creating directory. FolderName: \(folderName). \(error)")
			}
		}
	}
	
	private func getURLForFolder(folderName: String) -> URL? {
		guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
			return nil
		}
		return url.appendingPathComponent(folderName)
	}
	
	private func getURLForImage(imageName: String, folderName: String) -> URL? {
		guard let folderURL = getURLForFolder(folderName: folderName) else {
			return nil
		}
		return folderURL.appendingPathComponent(imageName + ".png")
	}
	
	func getURLForVideo(videoName: String, folderName: String) -> URL? {
		guard let folderURL = getURLForFolder(folderName: folderName) else {
			return nil
		}
		return folderURL.appendingPathComponent(videoName + ".mp4")
	}
	
	func deleteCache(folderName: String) {
		guard let paths = getURLForFolder(folderName: folderName)?.path else { return }
		
		do {
			let fileName = try FileManager.default.contentsOfDirectory(atPath: paths)
			
			for file in fileName {
				// For each file in the directory, create full path and delete the file
				let filePath = URL(fileURLWithPath: paths).appendingPathComponent(file).absoluteURL
				try FileManager.default.removeItem(at: filePath)
			}
		} catch let error {
			print(error)
		}
	}
}
