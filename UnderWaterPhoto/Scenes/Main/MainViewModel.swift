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

enum ContentSelectionState {
	case delete
	case open
}

class MainViewModel: ObservableObject {
	let repository: RepositoryProtocol
	let userDefaultsManager: DefaultsManagerable
	let authService: AuthServicable

	@Published var userName: String = L10n.MainViewModel.userName
	@Published var images: [ContentModel]
	@Published var state: States = .clear
	@Published var avatarImage: String = "photo"
	@Published var mail: String = "under@water.ru"
	@Published var toggle: Bool = false
	@Published var isModalPresented: Bool = false
	@Published var selectionState: ContentSelectionState = .open
	
	var headerActionButtonText: String {
		switch selectionState {
		case .delete:
			if isAnyContentSelected {
				return L10n.Extension.HeaderView.ActionButton.deleteSelected
			} else {
				return L10n.Extension.HeaderView.ActionButton.cancelSelection
			}
		case .open:
			return L10n.Extension.HeaderView.AddPhotoButtonView.text
		}
	}
	
	var isAnyContentSelected: Bool {
		return !self.images.filter({ $0.selected }).isEmpty
	}
	
	init(
		repository: RepositoryProtocol,
		userDefaultsManager: DefaultsManagerable,
		authService: AuthServicable
	) {
		self.repository = repository
		self.userDefaultsManager = userDefaultsManager
		self.authService = authService
		self.images = []
		if let userName = userDefaultsManager.fetchObject(type: String.self, for: .userName) {
			self.userName = userName
		}
		if let email = userDefaultsManager.fetchObject(type: String.self, for: .email) {
			self.mail = email
		}
	}
	
	func fetch() {
		if self.state != .settings {
			self.images = self.repository.getContent()
			self.state = self.images.isEmpty ? .clear : .main
			self.repository.updateContent { contentModels in
				for model in contentModels {
					var isExist = false
					for savedModel in self.images {
						if savedModel.id == model.downloadid {
							isExist = true
							continue
						}
					}
					if !isExist {
						self.images.append(
							ContentModel(
								id: model.downloadid,
								image: UIImage(named: "emptyImage1") ?? UIImage()
							)
						)
					}
				}
				
				self.state = self.images.isEmpty ? .clear : .main
				self.state = .main
				self.repository.downloadAndSave(
					firestoreModels: contentModels
				) { model in
					for (index, contentModel) in self.images.enumerated() {
						if contentModel.id == model.id {
							DispatchQueue.main.async {
								self.images[index].defaultid = model.defaultid
								self.images[index].defaultImage = model.defaultImage
								self.images[index].alphaSetting = model.alphaSetting
								self.images[index].image = model.image
								self.images[index].url = model.url
							}
							continue
						}
					}
				}
			}
		}
	}
	
	func isEmpty() -> Bool {
		return self.repository.getIsCacheEmpty()
	}
	
	func ttoggle() {
		toggle.toggle()
	}
	
	func deleteAccount() {
		
	}
	
	func deleteSelectedContent() {
		print("delete selected")
	}
	
}
