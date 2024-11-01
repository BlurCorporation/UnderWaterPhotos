//
//  SettingsView.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 30.10.2023.
//

import SwiftUI

struct SettingsView: View {
	@StateObject private var vm: SettingsViewModel
	var routeLanguageScreen: () -> Void
	var routeSubscriptionScreen: () -> Void
	
	@State var shouldDeleteAccount = false
	
	init(
		vm: @escaping @autoclosure () -> SettingsViewModel,
		routeLanguageScreen: @escaping () -> Void,
		routeSubscriptionScreen: @escaping () -> Void
	) {
		_vm = .init(wrappedValue: vm())
		self.routeLanguageScreen = routeLanguageScreen
		self.routeSubscriptionScreen = routeSubscriptionScreen
	}
	
	var body: some View {
		List(vm.settings) { setting in
			Button(action: {
				switch setting.id {
				case 0:
					routeLanguageScreen()
				case 1:
					vm.deleteEntities()
				case 2:
					routeSubscriptionScreen()
				case 3:
					shouldDeleteAccount = true
				case 4:
					vm.logout()
				default:
					break
				}
			}, label: {
				SettingRowView(
					setting: setting.settingName,
					additionalText: setting.additionalName,
					symbol: setting.symbol
				)
			})
			.listRowBackground(Color("blue"))
			.alert(
				"Удалить аккаунт?",
				isPresented: $shouldDeleteAccount
			) {
				Button("Да", role: .destructive) {
					vm.deleteAccount()
				}
				Button("Нет", role: .cancel) {}
			}
			.alert(
				"Не удалось удалить аккаунт",
				isPresented: $vm.isErrorDeleteAccount
			) {
				Button("Повторить") {
					vm.deleteAccount()
				}
				Button("Отмена", role: .cancel) {}
			}
		}
		.environment(\.defaultMinListRowHeight, 44)
		.frame(height: 176)
		.listStyle(.plain)
	}
}
