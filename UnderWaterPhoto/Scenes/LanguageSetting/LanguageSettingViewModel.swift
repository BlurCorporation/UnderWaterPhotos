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
            return "Русский"
        case .en:
            return "Английсикий"
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
