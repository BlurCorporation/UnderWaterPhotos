//
//  ImagePicker.swift
//  UnderWaterPhoto
//
//  Created by Андрей Барсуков on 24.12.2023.
//

import SwiftUI
import UIKit
import AVFoundation

struct ImagePicker: UIViewControllerRepresentable {
	@Binding var image: ContentModel?
	@Environment(\.presentationMode) private var presentationMode
	
	class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
		var parent: ImagePicker
		
		init(parent: ImagePicker) {
			self.parent = parent
		}
		
		func imagePickerController(
			_ picker: UIImagePickerController,
			didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
		) {
			if let uiImage = info[.originalImage] as? UIImage {
				let content = ContentModel(id: UUID(), image: uiImage)
				parent.image = content
				self.parent.presentationMode.wrappedValue.dismiss()
			}
			
			if let videourl = info[.mediaURL] as? URL {
				let avAsset = AVURLAsset(url: videourl, options: nil)
				avAsset.exportVideo(
					presetName: AVAssetExportPresetHighestQuality,
					outputFileType: AVFileType.mp4,
					fileExtension: "mp4"
				) { (mp4Url) in
					let content = ContentModel(
						id: UUID(),
						image: UIImage(),
						url: String(describing: mp4Url!)
					)
					self.parent.image = content
					
					self.parent.presentationMode.wrappedValue.dismiss()
				}
			}
			
		}
		
		func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
			parent.presentationMode.wrappedValue.dismiss()
		}
		
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(parent: self)
	}
	
	func makeUIViewController(context: Context) -> UIViewController {
		let picker = UIImagePickerController()
		picker.delegate = context.coordinator
		picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!//["public.movie", "public.photo"]
		return picker
	}
	
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

extension AVURLAsset {
	func exportVideo(
		presetName: String = AVAssetExportPresetHighestQuality,
		outputFileType: AVFileType = .mp4,
		fileExtension: String = "mp4",
		then completion: @escaping (URL?) -> Void
	) {
		let filename = url.deletingPathExtension().appendingPathExtension(fileExtension).lastPathComponent
		let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
		
		if let session = AVAssetExportSession(asset: self, presetName: presetName) {
			session.outputURL = outputURL
			session.outputFileType = outputFileType
			let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
			let range = CMTimeRangeMake(start: start, duration: duration)
			session.timeRange = range
			session.shouldOptimizeForNetworkUse = true
			session.exportAsynchronously {
				switch session.status {
				case .completed:
					completion(outputURL)
				case .cancelled:
					debugPrint("Video export cancelled.")
					completion(nil)
				case .failed:
					let errorMessage = session.error?.localizedDescription ?? "n/a"
					debugPrint("Video export failed with error: \(errorMessage)")
					completion(nil)
				default:
					break
				}
			}
		} else {
			completion(nil)
		}
	}
}
