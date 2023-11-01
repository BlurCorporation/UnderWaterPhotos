//
//  SettingsModel.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 30.10.2023.
//

import Foundation

struct SettingsModel: Identifiable {
    var id: Int
    var settingName: String
    var additionalName: String?
    var symbol: String?
}
