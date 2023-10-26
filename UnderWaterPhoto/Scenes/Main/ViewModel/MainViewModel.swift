//
//  MainViewModel.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 19.10.2023.
//

import Foundation

class MainViewModel: ObservableObject {
    @Published var images: [ImageModel] = []
    @Published var userName: String = "Александр"
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
    }
}
