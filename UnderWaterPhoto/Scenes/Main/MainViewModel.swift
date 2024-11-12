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
			self.repository.updateContent {
				DispatchQueue.main.async { [weak self] in
					guard let self = self else { return }
					self.updateImages()
				}
			}
		}
	}
	
	func updateImages() {
		self.images = self.repository.getContent()
		if self.images.isEmpty {
			self.state = .clear
		} else {
			self.state = .main
		}
	}
	
	func isEmpty() -> Bool {
		self.images = self.repository.getContent()
		return images.isEmpty
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
