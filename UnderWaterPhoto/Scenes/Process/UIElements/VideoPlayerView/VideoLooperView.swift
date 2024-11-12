import UIKit
import AVFoundation

class VideoLooperView: UIView {
	var video: URL?
	let videoPlayerView = VideoPlayerView()
	var playerLooper: AVPlayerLooper!
	
	@objc private let queuePlayer = AVQueuePlayer()
	
	private var token: NSKeyValueObservation?
	
	private var observer: NSKeyValueObservation? {
		willSet {
			guard let observer = observer else { return }
			observer.invalidate()
		}
	}
	
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
	
	func play(completion: @escaping () -> Void) {
		let playerItem = self.queuePlayer.items().first
		self.observer = playerItem?.observe(\.status, options: [.new, .old]) { [weak self] playerItem, change in
			guard let self = self else { return }
			if playerItem.status == .readyToPlay {
				completion()
				self.queuePlayer.play()
			}
		}
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
