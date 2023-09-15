//
//  ImageProcessingManager.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 10.09.2023.
//

import UIKit
import CoreImage

protocol ImageProcessingProtocol {
    func adjustWhiteBalance(image: UIImage, _ temperature: Float) -> UIImage // 2000 до 50000
    func adjustHLS(image: UIImage, hue: CGFloat, saturation: CGFloat, brightness: CGFloat) -> UIImage?
//    func adjustBrightness(image: UIImage, brightness: CGFloat) -> UIImage
    func adjustExposure(image: UIImage, exposure: CGFloat) -> UIImage // -5 до 5
    func adjustContrast(image: UIImage, contrast: CGFloat) -> UIImage // 0.25 до 4
    func sharpenImage(image: UIImage, sharpness: CGFloat) -> UIImage // 0 до 1
    func adjustBrightnessForHighlights(image: UIImage, brightness: CGFloat) -> UIImage // 0 до 1 (но можно попробовать от -1 до 1)
    func adjustBrightnessForShadows(image: UIImage, brightness: CGFloat) -> UIImage // -1 до 1
    func adjustHue(image: UIImage, hue: CGFloat) -> UIImage // -Float.pi / 4 до Float.pi / 4 (но можно -Float.pi до Float.pi)
    func adjustSaturation(image: UIImage, saturation: CGFloat) -> UIImage // 0 до 2
    func adjustColorfulness(image: UIImage, factor: CGFloat) -> UIImage
}

class ImageProcessing: ImageProcessingProtocol {
//    func adjustWhiteBalance(image: UIImage, _ kalvin: CGFloat) -> UIImage {
//        let ciImage = CIImage(image: image)
//
//        let filter = CIFilter(name: "CITemperatureAndTint")
//        filter?.setValue(ciImage, forKey: kCIInputImageKey)
//        filter?.setValue(CIVector(x: kalvin, y: 0), forKey: "inputTargetNeutral")
//
//        if let outputImage = filter?.outputImage {
//            let context = CIContext(options: nil)
//
//            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
//                return UIImage(cgImage: cgImage)
//            }
//        }
//        return UIImage(named: "emptyImage")!
//    }
    func adjustWhiteBalance(image: UIImage, _ temperature: Float) -> UIImage { //MARK: работает
        guard let cgImage = image.cgImage else { return UIImage(named: "emptyImage")! }

        let width = cgImage.width
        let height = cgImage.height
        let bitsPerComponent = 8
        let bytesPerRow = 4 * width
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return UIImage(named: "emptyImage")!
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        if let data = context.data {
            let buffer = UnsafeMutableBufferPointer<UInt8>(start: data.assumingMemoryBound(to: UInt8.self), count: bytesPerRow * height)
            
            for y in 0..<height {
                for x in 0..<width {
                    let offset = y * bytesPerRow + x * 4
                    
                    // Здесь вы можете выполнить операции с пикселями для настройки баланса белого
                    // Например, изменить значения красного и синего каналов в зависимости от температуры
                    
                    // Пример: Увеличение красного канала и уменьшение синего канала
                    let red = buffer[offset]
                    let blue = buffer[offset + 2]
                    let newRed = UInt8(max(min(255, Float(red) * (temperature / 5500)), 0))
                    let newBlue = UInt8(max(min(255, Float(blue) * (5500 / temperature)), 0))
                    
                    buffer[offset] = newRed
                    buffer[offset + 2] = newBlue
                }
            }
            
            if let newCGImage = context.makeImage() {
                let adjustedImage = UIImage(cgImage: newCGImage)
                return adjustedImage
            }
        }
        
        return UIImage(named: "emptyImage")!
    }

    func adjustHLS(image: UIImage, hue: CGFloat, saturation: CGFloat, brightness: CGFloat) -> UIImage? { //MARK: в процессе
        guard let cgImage = image.cgImage else { return nil }

        let width = cgImage.width
        let height = cgImage.height
        let bitsPerComponent = 8
        let bytesPerRow = 4 * width
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        if let data = context.data {
            let buffer = UnsafeMutableBufferPointer<UInt8>(start: data.assumingMemoryBound(to: UInt8.self), count: bytesPerRow * height)
            
            for y in 0..<height {
                for x in 0..<width {
                    let offset = y * bytesPerRow + x * 4
                    
                    // Извлекаем компоненты цвета из пикселя
                    var red = Float(buffer[offset]) / 255.0
                    var green = Float(buffer[offset + 1]) / 255.0
                    var blue = Float(buffer[offset + 2]) / 255.0
                    
                    // Преобразовываем в цветовое пространство HLS
                    var h: CGFloat = 0
                    var s: CGFloat = 0
                    var l: CGFloat = 0
                    UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0).getHue(&h, saturation: &s, brightness: &l, alpha: nil)
                    
                    // Применяем вручную заданные значения HLS
                    h = hue
                    s = saturation
                    l = brightness
                    
                    // Ограничиваем значения в пределах [0, 1]
                    s = max(0.0, min(1.0, s))
                    l = max(0.0, min(1.0, l))
                    
                    // Преобразуем обратно в RGB
                    var r: CGFloat = 0
                    var g: CGFloat = 0
                    var b: CGFloat = 0
                    UIColor(hue: h, saturation: s, brightness: l, alpha: 1.0).getRed(&r, green: &g, blue: &b, alpha: nil)
                    
                    // Присваиваем откорректированные значения компонентам цвета
                    buffer[offset] = UInt8(r * 255.0)
                    buffer[offset + 1] = UInt8(g * 255.0)
                    buffer[offset + 2] = UInt8(b * 255.0)
                }
            }
            
            if let newCGImage = context.makeImage() {
                let adjustedImage = UIImage(cgImage: newCGImage)
                return adjustedImage
            }
        }
        
        return nil
    }
    
//    func adjustBrightness(image: UIImage, brightness: CGFloat) -> UIImage {
//        guard let ciImage = CIImage(image: image) else { return UIImage(named: "emptyImage")! }
//
//        let filter = CIFilter(name: "CIColorControls")
//        filter?.setValue(ciImage, forKey: kCIInputImageKey)
//
//        // Устанавливаем значение яркости
//        filter?.setValue(brightness, forKey: kCIInputBrightnessKey)
//
//        if let outputImage = filter?.outputImage {
//            let context = CIContext(options: nil)
//
//            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
//                return UIImage(cgImage: cgImage)
//            }
//        }
//
//        return UIImage(named: "emptyImage")!
//    }
    
    func adjustExposure(image: UIImage, exposure: CGFloat) -> UIImage { //MARK: работает
        guard let ciImage = CIImage(image: image) else { return UIImage(named: "emptyImage")! }
        
        let filter = CIFilter(name: "CIExposureAdjust")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        // Устанавливаем значение экспозиции
        filter?.setValue(exposure, forKey: kCIInputEVKey)
        
        if let outputImage = filter?.outputImage {
            let context = CIContext(options: nil)
            
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage(named: "emptyImage")!
    }
    
    func adjustContrast(image: UIImage, contrast: CGFloat) -> UIImage { //MARK: работает
        guard let ciImage = CIImage(image: image) else { return UIImage(named: "emptyImage")! }
        
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        // Устанавливаем значение контраста
        filter?.setValue(contrast, forKey: kCIInputContrastKey)
        
        if let outputImage = filter?.outputImage {
            let context = CIContext(options: nil)
            
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage(named: "emptyImage")!
    }
    
    func sharpenImage(image: UIImage, sharpness: CGFloat) -> UIImage { //MARK: работает
        guard let ciImage = CIImage(image: image) else { return UIImage(named: "emptyImage")! }
        
        let filter = CIFilter(name: "CISharpenLuminance")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        // Устанавливаем значение резкости
        filter?.setValue(sharpness, forKey: kCIInputSharpnessKey)
        
        if let outputImage = filter?.outputImage {
            let context = CIContext(options: nil)
            
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage(named: "emptyImage")!
    }
    
    func adjustBrightnessForHighlights(image: UIImage, brightness: CGFloat) -> UIImage { //MARK:  сомнительно, НО окэй
        guard let ciImage = CIImage(image: image) else { return UIImage(named: "emptyImage")! }
        
        let filter = CIFilter(name: "CIHighlightShadowAdjust")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        // Устанавливаем значение яркости для светлых участков
        filter?.setValue(brightness, forKey: "inputHighlightAmount")
        
        if let outputImage = filter?.outputImage {
            let context = CIContext(options: nil)
            
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage(named: "emptyImage")!
    }
    
    func adjustBrightnessForShadows(image: UIImage, brightness: CGFloat) -> UIImage { //MARK: работает
        guard let ciImage = CIImage(image: image) else { return UIImage(named: "emptyImage")! }
        
        let filter = CIFilter(name: "CIHighlightShadowAdjust")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        /// Устанавливаем значение яркости для черных областей
        filter?.setValue(brightness, forKey: "inputShadowAmount")
        
        if let outputImage = filter?.outputImage {
            let context = CIContext(options: nil)
            
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage(named: "emptyImage")!
    }
    
    func adjustHue(image: UIImage, hue: CGFloat) -> UIImage { //MARK: работает
        guard let ciImage = CIImage(image: image) else { return UIImage(named: "emptyImage")! }
        
        let filter = CIFilter(name: "CIHueAdjust")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        // Устанавливаем значение оттенка
        filter?.setValue(hue, forKey: "inputAngle")
        
        if let outputImage = filter?.outputImage {
            let context = CIContext(options: nil)
            
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage(named: "emptyImage")!
    }
    
    func adjustSaturation(image: UIImage, saturation: CGFloat) -> UIImage { //MARK: работает
        guard let ciImage = CIImage(image: image) else { return UIImage(named: "emptyImage")! }
        
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        // Устанавливаем значение насыщенности
        filter?.setValue(saturation, forKey: kCIInputSaturationKey)
        
        if let outputImage = filter?.outputImage {
            let context = CIContext(options: nil)
            
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage(named: "emptyImage")!
    }
    
    func adjustColorfulness(image: UIImage, factor: CGFloat) -> UIImage { //MARK: - не работает
            guard let ciImage = CIImage(image: image) else { return UIImage(named: "emptyImage")! }
            
            let filter = CIFilter(name: "CIColorControls")
            filter?.setValue(ciImage, forKey: kCIInputImageKey)
            
            // Применяем насыщенность и контраст с использованием фактора
            filter?.setValue(1.0 + factor, forKey: kCIInputSaturationKey)
            filter?.setValue(1.0 + factor, forKey: kCIInputContrastKey)
            
            if let outputImage = filter?.outputImage {
                let context = CIContext(options: nil)
                
                if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
            
        return UIImage(named: "emptyImage")!
        }
}

