//
//  MainViewModel.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 19.10.2023.
//

import Foundation

enum States {
	case main
	case settings
	case clear
}

class MainViewModel: ObservableObject {
	@Published var userName: String = L10n.MainViewModel.userName
	@Published var images: [ContentModel] = []
	@Published var state: States = .clear
	@Published var avatarImage: String = "photo"
	@Published var mail: String = "under@water.ru"
	@Published var toggle: Bool = false
	
	let repository: Repository
	
	init(repository: Repository) {
		self.repository = repository
	}
	
	func fetch() {
		if state != .settings {
			self.images = self.repository.getContent()
			if self.images.isEmpty {
				self.state = .clear
			} else {
				self.state = .main
			}
			self.repository.updateContent {
				self.updateImages()
				print(self.images)
			}
		}
	}
	
	func updateImages() {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			self.images = self.repository.getContent()
			if self.images.isEmpty {
				self.state = .clear
			} else {
				self.state = .main
			}
		}
	}
	
	func isEmpty() -> Bool {
		self.images = self.repository.getContent()
		return images.isEmpty
	}
	
	func ttoggle() {
		toggle.toggle()
	}
}
