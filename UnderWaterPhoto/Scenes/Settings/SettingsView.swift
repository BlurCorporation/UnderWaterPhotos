//
//  SettingsView.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 30.10.2023.
//

import SwiftUI

struct SettingsView: View {
	@StateObject private var vm = SettingsViewModel()
	var routeLanguageScreen: () -> Void
	var routeSubscriptionScreen: () -> Void
	var logout: () -> Void
	let defaultsManager: DefaultsManagerable
	let repository: RepositoryProtocol
	
	var body: some View {
		NavigationView {
			List(vm.settings) { setting in
				SettingRowView(
					setting: setting.settingName,
					additionalText: setting.additionalName,
					symbol: setting.symbol
				)
				.onTapGesture {
					switch setting.id {
					case 0:
						routeLanguageScreen()
					case 1:
						repository.deleteEntities()
					case 2:
						routeSubscriptionScreen()
					case 3:
						break 
					case 4:
						defaultsManager.deleteObject(for: .isUserAuth)
						repository.deleteEntities()
						logout()
					default:
						break
					}
				}
				.listRowBackground(Color("blue"))
			}
			.environment(\.defaultMinListRowHeight, 44)
			.frame(height: 132)
			.listStyle(.plain)
		}
	}
}
