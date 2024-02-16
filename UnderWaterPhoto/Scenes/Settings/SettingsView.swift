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
    
    var body: some View {
        NavigationView {
            List(vm.settings) { setting in
                    SettingRowView(setting: setting.settingName,
                                   additionalText: setting.additionalName,
                                   symbol: setting.symbol)
                    .onTapGesture {
                        if setting.id == 0 {
                            routeLanguageScreen()
                        }
                        if setting.id == 1 {
                            Repository().deleteEntities()
                        }
                        if setting.id == 2 {
                            routeSubscriptionScreen()
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

//#Preview {
//    SettingsView(routeLanguageScreen: {})
//}
