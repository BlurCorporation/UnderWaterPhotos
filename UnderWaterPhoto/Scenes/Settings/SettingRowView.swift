//
//  SettingRowView.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 31.10.2023.
//

import SwiftUI

struct SettingRowView: View {
    var setting: String
    var additionalText: String?
    var symbol: String?
    
    var body: some View {
        VStack {
            ZStack {
                Color(L10n.SettingRowView.Body.VStack.Zstack.color)
                HStack {
                    Text(setting)
                        .foregroundColor(Color(L10n.SettingRowView.Body.VStack.Zstack.HStack.Text.Setting.foregroundColor))
                        .font(.system(size: 17, weight: .regular))
                    Spacer()
                    Text(additionalText ?? L10n.SettingRowView.quotes)
                        .foregroundColor(Color(L10n.SettingRowView.Body.VStack.Zstack.HStack.Text.AdditionalText.foregroundColor))
                        .font(.system(size: 17, weight: .regular))
                    Image(systemName: symbol ?? L10n.SettingRowView.quotes)
                        .foregroundColor(Color(L10n.SettingRowView.Body.VStack.Zstack.HStack.Image.Symbol.foregroundColor))
                        .font(.system(size: 17, weight: .regular))
                        .padding([.trailing], 16)
                }
            }
            Divider()
                .background(Color.white)
        }
    }
}

//#Preview {
//    LanguageSettingView()
//}
