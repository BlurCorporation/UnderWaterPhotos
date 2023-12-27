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
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        createFolderIfNeeded(folderName: folderName)
        
        guard
            let data = image.pngData(),
            let url = getURLForImage(imageName: imageName, folderName: folderName)
        else { return }
        
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image. ImageName: \(imageName) \(error)")
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard
            let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
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
