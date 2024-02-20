//
//  VideoProcessingManager.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 20.02.2024.
//

import Foundation
import AVFoundation

protocol VideoProcessingManagerProtocol {
    func process(_ video: String, completion: @escaping (Result<ContentModel, Error>) -> ())
}

class VideoProcessingManager {
    func extractAudio(videoURL: URL, completion: @escaping (URL) -> ()) {
        // Create a composition
        let composition = AVMutableComposition()
        do {
            let sourceUrl = videoURL
            let asset = AVURLAsset(url: sourceUrl)
            guard let audioAssetTrack = asset.tracks(withMediaType: AVMediaType.audio).first else { print("error audioAssetTrack"); return }
            guard let audioCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid) else { print("error audioCompositionTrack"); return }
            try audioCompositionTrack.insertTimeRange(audioAssetTrack.timeRange, of: audioAssetTrack, at: CMTime.zero)
        } catch {
            print(error)
        }
        
        // Get url for output
        let outputUrl = URL(fileURLWithPath: NSTemporaryDirectory() + "out.m4a")
        if FileManager.default.fileExists(atPath: outputUrl.path) {
            try? FileManager.default.removeItem(atPath: outputUrl.path)
        }
        
        // Create an export session
        let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetPassthrough)!
        exportSession.outputFileType = AVFileType.m4a
        exportSession.outputURL = outputUrl
        
        // Export file
        exportSession.exportAsynchronously {
            guard case exportSession.status = AVAssetExportSession.Status.completed else { print("error audio"); return }
            guard let outputURL = exportSession.outputURL else { print("error export output"); return }
            completion(outputURL)
        }
    }
    
    func createVideo(from images: [UIImage], outputURL: URL, frameDuration: CMTime, completion: @escaping (Bool) -> Void) {
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: NSNumber(value: Float(images.first!.size.width)),
            AVVideoHeightKey: NSNumber(value: Float(images.first!.size.height))
        ]
        
        let writer = try! AVAssetWriter(outputURL: outputURL, fileType: .mp4)
        let writerInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: writerInput, sourcePixelBufferAttributes: nil)
        
        writer.add(writerInput)
        writer.startWriting()
        writer.startSession(atSourceTime: .zero)
        
        var frameCount = 0
        let frameDuration = frameDuration
        
        writerInput.requestMediaDataWhenReady(on: DispatchQueue(label: "videoQueue")) {
            for image in images {
                while !writerInput.isReadyForMoreMediaData { }
                if let buffer = self.pixelBuffer(from: image) {
                    let frameTime = CMTime(value: Int64(frameCount), timescale: frameDuration.timescale)
                    adaptor.append(buffer, withPresentationTime: frameTime)
                    frameCount += 1
                }
            }
            
            writerInput.markAsFinished()
            writer.finishWriting {
                print(writer.status)
                completion(writer.status == .completed)
            }
        }
    }
    
    func pixelBuffer(from image: UIImage) -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
    
    func mergeVideoWithAudio(videoUrl: URL, audioUrl: URL, success: @escaping ((URL) -> Void), failure: @escaping ((Error?) -> Void)) {
        
        
        let mixComposition: AVMutableComposition = AVMutableComposition()
        var mutableCompositionVideoTrack: [AVMutableCompositionTrack] = []
        var mutableCompositionAudioTrack: [AVMutableCompositionTrack] = []
        let totalVideoCompositionInstruction : AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()
        
        let aVideoAsset: AVAsset = AVAsset(url: videoUrl)
        let aAudioAsset: AVAsset = AVAsset(url: audioUrl)
        
        if let videoTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid), let audioTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) {
            mutableCompositionVideoTrack.append(videoTrack)
            mutableCompositionAudioTrack.append(audioTrack)
            
            if let aVideoAssetTrack: AVAssetTrack = aVideoAsset.tracks(withMediaType: .video).first, let aAudioAssetTrack: AVAssetTrack = aAudioAsset.tracks(withMediaType: .audio).first {
                do {
                    try mutableCompositionVideoTrack.first?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: aVideoAssetTrack.timeRange.duration), of: aVideoAssetTrack, at: CMTime.zero)
                    try mutableCompositionAudioTrack.first?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: aVideoAssetTrack.timeRange.duration), of: aAudioAssetTrack, at: CMTime.zero)
                    videoTrack.preferredTransform = aVideoAssetTrack.preferredTransform
                    
                } catch{
                    print(error)
                }
                
                
                totalVideoCompositionInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero,duration: aVideoAssetTrack.timeRange.duration)
            }
        }
        
        let mutableVideoComposition: AVMutableVideoComposition = AVMutableVideoComposition()
        mutableVideoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        mutableVideoComposition.renderSize = CGSize(width: 480, height: 640)
        
        if let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let outputURL = URL(fileURLWithPath: documentsPath).appendingPathComponent("\("fileName").m4v")
            
            do {
                if FileManager.default.fileExists(atPath: outputURL.path) {
                    
                    try FileManager.default.removeItem(at: outputURL)
                }
            } catch { }
            
            if let exportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality) {
                exportSession.outputURL = outputURL
                exportSession.outputFileType = AVFileType.mp4
                exportSession.shouldOptimizeForNetworkUse = true
                
                /// try to export the file and handle the status cases
                exportSession.exportAsynchronously(completionHandler: {
                    switch exportSession.status {
                    case .failed:
                        if let _error = exportSession.error {
                            failure(_error)
                        }
                        
                    case .cancelled:
                        if let _error = exportSession.error {
                            failure(_error)
                        }
                        
                    default:
                        print("finished")
                        success(outputURL)
                    }
                })
            } else {
//                failure(CustomError(title: "nil", description: "nil", code: 999))
                failure(nil)
            }
        }
    }
}

extension VideoProcessingManager: VideoProcessingManagerProtocol {
    func process(_ video: String, completion: @escaping (Result<ContentModel, Error>) -> ()) {
        do {
            
            let processedVideo = try CVWrapper.process(withVideos: video)
            extractAudio(videoURL: URL(string: "file://\(video)")!, completion: { audiourl in
                // создаём временную директорию, потом удаляем в репозитории
                guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
                    return
                }
                
                let videoUUID = UUID()
                
                guard let outputURL: URL = URL(string: String(url.appendingPathComponent("\(videoUUID).mp4").absoluteString)) else {
                    return
                }
                
                let frameDuration = CMTime(value: 1, timescale: CMTimeScale(processedVideo.frames))
                
                let uiimageArray: [UIImage] = processedVideo.images.compactMap { $0 as? UIImage }
                var contentModel = ContentModel(id: videoUUID, image: uiimageArray.first ?? UIImage())
                self.createVideo(from: uiimageArray, outputURL: outputURL, frameDuration: frameDuration) { /*[weak self]*/ success in
                    if success {
                        print("Видео успешно создано")
                        self.mergeVideoWithAudio(videoUrl: outputURL, audioUrl: audiourl, success: { url in
                            contentModel.url = url.absoluteString
                            completion(.success(contentModel))
//                            self?.viewController?.changeVideo(url: url)
//                            self?.videoURL = url.absoluteString
                        }, failure: { error in
                            completion(.failure(error ?? CustomError(title: "123", description: "123", code: 2134124324523)))
//                            print(error?.localizedDescription)
                        })
                        print("aaaa")
                    } else {
                        print("Произошла ошибка при создании видео")
                    }
                }
            })
        } catch {
            print("error")
        }
    }
}

struct CustomError: LocalizedError {
    var title: String?
    var code: Int
    var errorDescription: String? { return _description }
    var failureReason: String? { return _description }

    private var _description: String

    init(title: String?, description: String, code: Int) {
        self.title = title ?? "Error"
        self._description = description
        self.code = code
    }
}
