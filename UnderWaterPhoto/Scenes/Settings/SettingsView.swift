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
    let repository: Repository
    
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
                            repository.deleteEntities()
                        case 2:
                            routeSubscriptionScreen()
                        case 4:
                            defaultsManager.deleteObject(for: .isUserAuth)
                            logout()
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
