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
        SettingsModel(id: 0, settingName: L10n.SettingsViewModel.Settings.Id._0.settingName, additionalName: L10n.SettingsViewModel.Settings.Id._0.additionalName, symbol: L10n.SettingsViewModel.Settings.Id._0.symbol),
        SettingsModel(id: 1, settingName: L10n.SettingsViewModel.Settings.Id._1.settingName),
        SettingsModel(id: 2, settingName: L10n.SettingsViewModel.Settings.Id._2.settingName),
        SettingsModel(id: 3, settingName: L10n.SettingsViewModel.Settings.Id._3.settingName),
        SettingsModel(id: 4, settingName: L10n.SettingsViewModel.Settings.Id._4.settingName),
    ]
}
