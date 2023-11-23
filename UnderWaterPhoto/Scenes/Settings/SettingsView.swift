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
        NavigationView {
            List(vm.settings) { setting in
                    SettingRowView(setting: setting.settingName,
                                   additionalText: setting.additionalName,
                                   symbol: setting.symbol,
                                   routeLanguageScreen: routeLanguageScreen)
                    .onTapGesture {
                        if setting.id == 0 {
                            routeLanguageScreen()
                        }
                    }
                .listRowBackground(Color("blue"))
            }
            .environment(\.defaultMinListRowHeight, 44)
            .frame(height: 220)
            .listStyle(.plain)
        }
    }
}

#Preview {
    SettingsView(routeLanguageScreen: {})
}
