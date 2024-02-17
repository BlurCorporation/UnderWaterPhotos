//
//  MainViewModel.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 19.10.2023.
//

import Foundation

enum States {
    case main
    case settings
    case clear
}

class MainViewModel: ObservableObject {
    @Published var userName: String = L10n.MainViewModel.userName
    @Published var images: [ContentModel] = []
    @Published var state: States = .clear
    @Published var avatarImage: String = "photo"
    @Published var mail: String = "under@water.ru"
    @Published var toggle: Bool = false
    
    let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
        fetch()
    }
    
    func fetch() {
        if state != .settings {
            images = repository.getContent()
            print(images[1].url)
            if images.isEmpty {
                state = .clear
            } else {
                state = .main
            }
        }
    }
    
    func isEmpty() -> Bool {
        return images.isEmpty
    }
    
    func ttoggle() {
        toggle.toggle()
    }
}
