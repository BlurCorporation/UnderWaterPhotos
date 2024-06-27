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
                        switch setting.id {
                        case 0:
                            routeLanguageScreen()
                        case 1:
                            Repository().deleteEntities()
                        case 2:
                            routeSubscriptionScreen()
                        case 3:
                            break
                        default:
                            break
                        }
                    }
                    .listRowBackground(Color("blue"))
            }
            .environment(\.defaultMinListRowHeight, 44)
            .frame(height: 176)
            .listStyle(.plain)
        }
    }
}

//#Preview {
//    SettingsView(routeLanguageScreen: {})
//}
