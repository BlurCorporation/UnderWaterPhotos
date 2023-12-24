//
//  ImagePicker.swift
//  UnderWaterPhoto
//
//  Created by Андрей Барсуков on 24.12.2023.
//

import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    typealias UIViewControllerType = UIImagePickerController
}
