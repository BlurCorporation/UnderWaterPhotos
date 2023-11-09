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
    var routeLanguageScreen: () -> ()
    
    var body: some View {
        VStack {
            HStack {
                Text(setting)
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .regular))
                Spacer()
                Text(additionalText ?? "")
                    .foregroundColor(Color("grey"))
                    .font(.system(size: 17, weight: .regular))
                Image(systemName: symbol ?? "")
                    .foregroundColor(Color("grey"))
                    .font(.system(size: 17, weight: .regular))
                    .padding([.trailing], 16)
            }
            .onTapGesture {
                routeLanguageScreen()
            }
            Divider()
                .background(Color.white)
        }
        .padding([.leading], 16)
        .frame(height: 44)
    }
}
