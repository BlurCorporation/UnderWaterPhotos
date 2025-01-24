//
//  Data.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 20.08.2024.
//

import AVFoundation

extension Data {
	func getAVAsset() -> AVURLAsset {
		let directory = NSTemporaryDirectory()
		let fileName = "\(NSUUID().uuidString).mov"
		let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName])
		try! self.write(to: fullURL!)
		let asset = AVURLAsset(url: fullURL!)
		return asset
	}
}
