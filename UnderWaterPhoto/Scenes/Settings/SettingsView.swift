//
//  SettingsView.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 30.10.2023.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var vm = SettingsViewModel()
    var routeLanguageScreen: () -> ()
    
    var body: some View {
        VStack {
            ForEach(vm.settings) { setting in
                SettingRowView(setting: setting.settingName,
                               additionalText: setting.additionalName,
                               symbol: setting.symbol,
                               routeLanguageScreen: routeLanguageScreen)
                .onTapGesture {
                    
                }
            }
        }
    }
}
