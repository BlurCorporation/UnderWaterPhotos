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
	
	// MARK: - Dependencies
	
	let repository: RepositoryProtocol
	let userDefaultsManager: DefaultsManagerable
	let authService: AuthServicable
	
	// MARK: - Internal Properties
	
	@Published var userName = L10n.MainViewModel.userName
	@Published var images: [ContentModel]
	@Published var state: States = .clear
	@Published var avatarImage = "photo"
	@Published var mail = "under@water.ru"
	@Published var toggle = false
	@Published var isModalPresented = false
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
	
	// MARK: - Lifecycle
	
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
	
	// MARK: - Private Methods
	
	private func showPreloadedContent(_ contentModels: [ContentFirestoreModel]) {
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
	}
	
	private func downloadAndShowContent(_ contentModels: [ContentFirestoreModel]) {
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
	
	// MARK: - Internal Methods
	
	func fetch() {
		if self.state != .settings {
			self.images = self.repository.getContent()
			self.state = .main
			// TODO: In next version
//			self.repository.updateContent { contentModels in
//				self.showPreloadedContent(contentModels)
//				self.downloadAndShowContent(contentModels)
//			}
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
		var newContentModels: [ContentModel] = []
		for content in self.images {
			if content.selected {
				self.repository.deleteContent(contentModel: content)
			} else {
				newContentModels.append(content)
			}
		}
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			self.images = newContentModels
			self.state = self.images.isEmpty ? .clear : .main
			if self.state == .clear {
				self.selectionState = .open
			}
		}
	}
}
