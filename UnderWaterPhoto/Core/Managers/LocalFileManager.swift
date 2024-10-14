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
		completion: @escaping (Bool) -> Void
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
			completion(true)
		}
	}
	
	func getContent(imageName: String, folderName: String) -> ContentModel? {
		guard
			let imageURL = getURLForImage(imageName: imageName, folderName: folderName),
			
				FileManager.default.fileExists(atPath: imageURL.path) else {
			return nil
		}
		
		var videoURL: URL? = getURLForVideo(videoName: imageName, folderName: folderName)
		
		do {
			_ = try FileManager.default.attributesOfItem(atPath: videoURL!.path)[.size] as? UInt64
		} catch {
			videoURL = nil
		}
		
		guard
			let image = UIImage(contentsOfFile: imageURL.path)
		else {
			return nil
		}
		
		return ContentModel(id: imageName, image: image, url: videoURL?.absoluteString)
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
