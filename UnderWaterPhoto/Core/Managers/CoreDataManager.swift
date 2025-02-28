//
//  CoreDataManager.swift
//  UnderWaterPhoto
//
//  Created by USER on 14.12.2023.
//

import CoreData

final class CoreDataManager {
	static let shared = CoreDataManager()
	let container: NSPersistentContainer
	let context: NSManagedObjectContext
	
	init() {
		container = NSPersistentContainer(name: "")
		container.loadPersistentStores { description, error in
			if let error = error {
				print(error.localizedDescription)
			}
		}
		context = container.viewContext
	}
	
	func delete(_ object: NSManagedObject) {
		context.delete(object)
	}
	
	func save() {
		try? context.save()
	}
}
