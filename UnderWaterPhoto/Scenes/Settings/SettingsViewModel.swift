//
//  SettingsViewModel.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 30.10.2023.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
	
	private let repository: RepositoryProtocol
	private let defaultsManager: DefaultsManagerable
	private let routeToAuthScreen: () -> Void
	private let authService: AuthServicable
	
	@Published var settings: [SettingsModel] = [
//        SettingsModel(id: 0, settingName: L10n.SettingsViewModel.Settings.Id._0.settingName, additionalName: L10n.SettingsViewModel.Settings.Id._0.additionalName, symbol: "chevron.right"),
		SettingsModel(id: 1, settingName: L10n.SettingsViewModel.Settings.Id._1.settingName),
//		SettingsModel(id: 2, settingName: L10n.SettingsViewModel.Settings.Id._2.settingName),
//		SettingsModel(id: 3, settingName: L10n.SettingsViewModel.Settings.Id._3.settingName),
//		SettingsModel(id: 4, settingName: L10n.SettingsViewModel.Settings.Id._4.settingName),
	]
	@Published var isErrorDeleteAccount = false
	
	init(
		repository: RepositoryProtocol,
		defaultsManager: DefaultsManagerable,
		authService: AuthServicable,
		routeToAuthScreen: @escaping () -> Void
	) {
		self.repository = repository
		self.defaultsManager = defaultsManager
		self.routeToAuthScreen = routeToAuthScreen
		self.authService = authService
	}
	
	func deleteEntities() {
		self.repository.deleteLocalEntities()
	}
	
	func logout() {
		self.deleteEntities()
		self.defaultsManager.deleteObject(for: .isUserAuth)
		self.routeToAuthScreen()
	}
	
	func deleteAccount() {
		self.authService.deleteUser { result in
			switch result {
			case .success:
				self.repository.deleteRemoteEntities()
				self.logout()
			case .failure:
				self.isErrorDeleteAccount = true
			}
		}
	}
}
