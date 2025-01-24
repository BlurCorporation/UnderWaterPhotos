//
//  LanguageSettingViewModel.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 19.11.2023.
//

import Foundation

enum Languages {
	case rus
	case en
	
	var title: String {
		switch self {
		case .rus:
			return L10n.LanguageSettingViewModel.Languages.Title.rus
		case .en:
			return L10n.LanguageSettingViewModel.Languages.Title.en
		}
	}
}

class LanguageSettingViewModel: ObservableObject {
	@Published var selectedLanguage: Languages = .rus
	@Published var languages: [Languages] = [.rus, .en]
	
	func changeLanguage(language: Languages) {
		selectedLanguage = language
	}
}
