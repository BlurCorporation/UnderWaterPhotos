//
//  SettingsViewModel.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 30.10.2023.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var settings: [SettingsModel] = [
        SettingsModel(id: 0, settingName: "Язык приложения", additionalName: "Русский", symbol: "chevron.right"),
        SettingsModel(id: 1, settingName: "Очистить кэш"),
        SettingsModel(id: 2, settingName: "Подписка"),
        SettingsModel(id: 3, settingName: "Удалить аккаунт"),
        SettingsModel(id: 4, settingName: "Выйти из аккаунта"),
    ]
}
