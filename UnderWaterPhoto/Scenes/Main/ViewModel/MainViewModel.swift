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
    @Published var images: [ImageModel] = []
    @Published var userName: String = "Александр"
    @Published var state: States = .clear
    @Published var avatarImage: String = "photo"
    @Published var mail: String = "under@water.ru"
    @Published var toggle: Bool = false
    
    func fetch() {
        images = [
            ImageModel(id: UUID(), imageName: "emptyImage1"),
            ImageModel(id: UUID(), imageName: "emptyImage1"),
            ImageModel(id: UUID(), imageName: "emptyImage1"),
            ImageModel(id: UUID(), imageName: "emptyImage1"),
            ImageModel(id: UUID(), imageName: "emptyImage1"),
            ImageModel(id: UUID(), imageName: "emptyImage1"),
            ImageModel(id: UUID(), imageName: "emptyImage1"),
            ImageModel(id: UUID(), imageName: "emptyImage1"),
            ImageModel(id: UUID(), imageName: "emptyImage1"),
            ImageModel(id: UUID(), imageName: "emptyImage1"),
            ImageModel(id: UUID(), imageName: "emptyImage1"),
            ImageModel(id: UUID(), imageName: "emptyImage1")
        ]
        if images.isEmpty {
            state = .clear
        } else {
            state = .main
        }
    }
    
    func isEmpty() -> Bool {
        return images.isEmpty
    }
    
    func ttoggle() {
        toggle.toggle()
    }
}