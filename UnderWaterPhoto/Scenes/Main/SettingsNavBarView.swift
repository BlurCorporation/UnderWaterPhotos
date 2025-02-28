//
//  SettingsHeaderView.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 02.11.2023.
//

import SwiftUI

struct SettingsNavBarView: View {
	var avatarImage: String
	var name: String
	var mail: String
	
	var body: some View {
		HStack(spacing: 12) {
            Image(avatarImage)
                .resizable()  // Позволяет изменять размер изображения
                .scaledToFill()  // Масштабирует изображение с заполнением
                .frame(width: 40, height: 40)  // Ограничение размеров
                
			VStack(alignment: .leading) {
				Text(name)
					.foregroundColor(Color("white"))
					.font(.system(size: 20, weight: .medium))
				Text(mail)
					.foregroundColor(Color("grey"))
					.font(.system(size: 18, weight: .regular))
			}
			Spacer()
		}
        .padding([.top], 10)
        .padding([.leading], 20)
	}
}
