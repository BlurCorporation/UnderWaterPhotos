//
//  Repository.swift
//  UnderWaterPhoto
//
//  Created by USER on 14.12.2023.
//

import Foundation
import CoreData

class Repository {
    private let fileManager = LocalFileManager.instance
    private let coreDataManager = CoreDataManager.shared
    private var imagesCoreData = [Images]()
    
    enum entityName: String {
        case video
        case image
        
        var string: String {
            switch self {
            case .video:
                return "Videos"
            case .image:
                return "Images"
            }
        }
    }
    
    func deleteEntities() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try coreDataManager.context.execute(deleteRequest)
            try coreDataManager.context.save()
            fileManager.deleteCache(folderName: "ImagesFolder")
        } catch {
            print ("There was an error")
        }
    }
    
    func getImages () -> [ImageModel] {
        getEntity(entity: .image)
        print(imagesCoreData.count)
        var images = [ImageModel]()
        
        for i in imagesCoreData {
            let id = (i.id?.uuidString)!
            if let savedImage = fileManager.getImage(imageName: id, folderName: "ImagesFolder") {
                let modell = ImageModel(id: i.id!, image: savedImage)
                if !images.contains(where: { model in
                    model == modell
                }) {
                    images.append(modell)
                }
            }
        }
        
        return images
    }
    
    func addImage(uiimage: UIImage) {
        let image = Images(context: coreDataManager.context)
        let id = UUID()
        image.id = id
        save()
        fileManager.saveImage(image: uiimage, imageName: id.uuidString, folderName: "ImagesFolder")
    }
    
    func save() {
        imagesCoreData.removeAll()
        coreDataManager.save()
        getEntity(entity: .image)
    }
    
    func getEntity(entity: entityName) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
        do {
            switch entity {
            case .video:
                print()
            case .image:
                imagesCoreData = try coreDataManager.context.fetch(request) as [Images]
            }
        } catch let error {
            print("Error fetching entity: \(error.localizedDescription)")
        }
    }
}
