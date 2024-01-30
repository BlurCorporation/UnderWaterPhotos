//
//  Presenter.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 03.09.2023.
//

import CoreImage
import UIKit
import AVFoundation

enum ProcessButtonType {
    case change
    case process
}

protocol ProcessPresenterProtocol: AnyObject {
    func changeImage(image: UIImage, value: Float)
    func backButtonPressed()
}

class ProcessPresenter {
    weak var viewController: ProcessViewControllerProtocol?
        
    //MARK: - PrivateProperties
    
    private let sceneBuildManager: Buildable
    private var processButtonType: ProcessButtonType = .change
    private var wasProcessed: Bool = false
    //MARK: - Initialize
    
    init(sceneBuildManager: Buildable) {
        self.sceneBuildManager = sceneBuildManager
    }
}

extension ProcessPresenter: ProcessPresenterProtocol {
    func backButtonPressed() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func changeImage(image: UIImage, value: Float) {
        switch processButtonType {
        case .change:
            processButtonType = .process
            viewController?.changeToProcess()
        case .process:
            viewController?.showBottomSaveSheet()
            Task {
                let url = URL(fileURLWithPath: Bundle.main.path(forResource: "testVideo", ofType: "MP4")!).absoluteString
                let processedVideo = try await process(video: String(url.dropFirst(7)))//process(video: String(url.dropFirst(7)))
                print(processedVideo.images)
                
                let tempPath = NSTemporaryDirectory() as String
                let outputPath = (tempPath as NSString).appendingPathComponent("outputVideo7.mp4")
                let outputURL = URL(fileURLWithPath: outputPath)
                
                let frameDuration = CMTime(value: 1, timescale: CMTimeScale(processedVideo.frames))
                
                let uiimageArray: [UIImage] = processedVideo.images.compactMap { $0 as? UIImage }
                
                createVideo(from: uiimageArray, outputURL: outputURL, frameDuration: frameDuration) { success in
                    if success {
                        print("Видео успешно создано")
                        self.viewController?.changeVideo(url: outputURL)
                    } else {
                        print("Произошла ошибка при создании видео")
                    }
                }
                
                
            }
            if !wasProcessed {
                wasProcessed = true
                Task {
                    let newImage: UIImage = try await process(image: image)
//                    self.viewController?.uploadImage(image: newImage)
//                    let url = URL(fileURLWithPath: Bundle.main.path(forResource: "testVideo", ofType: "MP4")!).absoluteString
//                    let string = try await process(video: url)
//                    print(string)
//                    viewController?.changeVideo(url: URL(string: string)!)
                }
            }
        }
    }
    
    func process(image: UIImage) async throws -> UIImage{
        let newImage = try CVWrapper.process(withImages: image)
        return newImage
    }
    
    func process(video: String) async throws -> FramesOfProcessedVideo {
        let processedVideo = try CVWrapper.process(withVideos: video)// as NSArray as! [UIImage]
//        print("firstObject: \(type(of: string.firstObject as! UIImage))")
        
//        return uiimageArray
        return processedVideo
    }
}


extension ProcessPresenter {
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
}
