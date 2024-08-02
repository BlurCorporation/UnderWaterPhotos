//
//  VideoLooperView.swift
//  MiniСinema
//
//  Created by Алексей Пархоменко on 11/03/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit
import AVFoundation

class VideoLooperView: UIView {
	var video: URL?
	let videoPlayerView = VideoPlayerView()
	var playerLooper: AVPlayerLooper!
	
	@objc private let queuePlayer = AVQueuePlayer()
	
	private var token: NSKeyValueObservation?
	
	init() {
		super.init(frame: .zero)
	}
	
	override func layoutSubviews() {
		addSubview(videoPlayerView)
		videoPlayerView.frame = bounds
	}
	
	func addVideo(video: URL?) {
		if let oldVideo = self.video {
			let asset = AVURLAsset(url: oldVideo)
			let item = AVPlayerItem(asset: asset)
			queuePlayer.remove(item)
		}
		
		self.video = video
		initilizePlayer()
	}
	
	private func initilizePlayer() {
		videoPlayerView.player = queuePlayer
		addAllVideosToPlayer()
		queuePlayer.play()
	}
	
	func pause() {
		queuePlayer.pause()
	}
	
	func play() {
		queuePlayer.play()
	}
	
	private func addAllVideosToPlayer() {
		guard let video = video else { return }
		let asset = AVURLAsset(url: video)
		
		let item = AVPlayerItem(asset: asset)
		
		queuePlayer.insert(item, after: queuePlayer.items().last)
		self.playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: item)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
