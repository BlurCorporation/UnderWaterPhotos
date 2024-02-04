//
//  Repository.swift
//  UnderWaterPhoto
//
//  Created by USER on 14.12.2023.
//

import Foundation
import CoreData
import UIKit

class Repository {
    private let fileManager = LocalFileManager.instance
    private let coreDataManager = CoreDataManager.shared
    private var contentCoreData = [ContentEntity]()
    
    
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
            if let savedContent = fileManager.getImage(imageName: id, folderName: "ContentFolder") {
                let _model = ContentModel(id: i.id!, image: savedContent, url: i.url)
                if !images.contains(where: { model in
                    model == _model
                }) {
                    images.append(_model)
                }
            }
        }
        
        return images
    }
    
    func addContent(uiimage: UIImage, url: String? = nil) {
        let content = ContentEntity(context: coreDataManager.context)
        let id = UUID()
        content.id = id
        content.url = url
        save()
        fileManager.saveImage(image: uiimage, imageName: id.uuidString, folderName: "ContentFolder")
    }
    
    func save() {
        contentCoreData.removeAll()
        coreDataManager.save()
    }
    
    func getContentEntity() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ContentEntity")
        do {
            contentCoreData = try coreDataManager.context.fetch(request) as [ContentEntity]
        } catch let error {
            print("Error fetching entity: \(error.localizedDescription)")
        }
    }
}
