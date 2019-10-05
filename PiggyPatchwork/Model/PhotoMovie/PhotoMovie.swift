//
//  VideoWritter.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/17.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

protocol MovieUrlProviderDelegate: AnyObject {
    
    func provider(_ provider: ImageAnimator, didGet url: String)
}

struct RenderSettings {
    
    var width: CGFloat = 1500
    
    var height: CGFloat = 844
    
    var fps: Int32 = 1   // 1 frames per second
    
    var avCodecKey = AVVideoCodecType.h264
    
    var videoFilename = "renderExportVideo"
    
    var videoFilenameExt = "mp4"
    
    var size: CGSize {
        
        return CGSize(width: width, height: height)
    }
    
    var outputURL: NSURL {
        
        let fileManager = FileManager.default
        
        if let tmpDirURL = try? fileManager.url(for: .cachesDirectory,
                                                in: .userDomainMask,
                                                appropriateFor: nil,
                                                create: true) {
            
            return tmpDirURL.appendingPathComponent(videoFilename).appendingPathExtension(videoFilenameExt) as NSURL
        }
        
        fatalError("URLForDirectory() failed")
    }
}

class VideoWriter {
    
    let renderSettings: RenderSettings
    
    var videoWriter: AVAssetWriter!
    
    var videoWriterInput: AVAssetWriterInput!
    
    var pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor!
    
    var isReadyForData: Bool {
        
        return videoWriterInput?.isReadyForMoreMediaData ?? false
    }
    
    class func pixelBufferFromImage(
        image: UIImage,
        pixelBufferPool: CVPixelBufferPool,
        size: CGSize
    ) -> CVPixelBuffer {
        
        var pixelBufferOut: CVPixelBuffer?
        
        let status = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pixelBufferPool, &pixelBufferOut)
        
        if status != kCVReturnSuccess {
            
            fatalError("CVPixelBufferPoolCreatePixelBuffer() failed")
        }
        
        let pixelBuffer = pixelBufferOut!
        
        CVPixelBufferLockBaseAddress(pixelBuffer, [])
        
        let data = CVPixelBufferGetBaseAddress(pixelBuffer)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        
        let context = CGContext(data: data,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
                                space: rgbColorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        context?.clear(CGRect(x: 0,
                              y: 0,
                              width: size.width,
                              height: size.height))
        
        let horizontalRatio = size.width / image.size.width
        
        let verticalRatio = size.height / image.size.height
        
        let aspectRatio = min(horizontalRatio, verticalRatio) // ScaleAspectFit
        
        let newSize = CGSize(width: image.size.width * aspectRatio, height: image.size.height * aspectRatio)
        
        let newX = newSize.width < size.width ? (size.width - newSize.width) / 2 : 0
        
        let newY = newSize.height < size.height ? (size.height - newSize.height) / 2 : 0
        
        context?.concatenate(CGAffineTransform.identity)
        
        context?.draw(image.cgImage!,
                      in: CGRect(x: newX,
                                 y: newY,
                                 width: newSize.width,
                                 height: newSize.height))
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer, [])
        
        return pixelBuffer
    }
    
    init(renderSettings: RenderSettings) {
        
        self.renderSettings = renderSettings
    }
    
    func start() {
        
        let avOutputSettings: [String: AnyObject] = [
            AVVideoCodecKey: renderSettings.avCodecKey as AnyObject,
            AVVideoWidthKey: NSNumber(value: Float(renderSettings.width)),
            AVVideoHeightKey: NSNumber(value: Float(renderSettings.height))
        ]
        
        func createPixelBufferAdaptor() {
            
            let sourcePixelBufferAttributesDictionary = [
                kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32ARGB),
                kCVPixelBufferWidthKey as String: NSNumber(value: Float(renderSettings.width)),
                kCVPixelBufferHeightKey as String: NSNumber(value: Float(renderSettings.height))
            ]
            
            pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(
                
                assetWriterInput: videoWriterInput,
                
                sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary)
        }
        
        func createAssetWriter(outputURL: NSURL) -> AVAssetWriter {
            
            guard
                let assetWriter = try? AVAssetWriter(outputURL: outputURL as URL, fileType: AVFileType.mp4)
            else {
                fatalError("AVAssetWriter() failed")
            }
            
            guard
                assetWriter.canApply(outputSettings: avOutputSettings, forMediaType: AVMediaType.video)
            else {
                fatalError("canApplyOutputSettings() failed")
            }
            
            return assetWriter
        }
        
        videoWriter = createAssetWriter(outputURL: renderSettings.outputURL)
        
        videoWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video,
                                              outputSettings: avOutputSettings)
        
        if videoWriter.canAdd(videoWriterInput) {
            videoWriter.add(videoWriterInput)
            
        } else {
            
            fatalError("canAddInput() returned false")
        }
        
        createPixelBufferAdaptor()
        
        if videoWriter.startWriting() == false {
            
            fatalError("startWriting() failed")
        }
        
        videoWriter.startSession(atSourceTime: CMTime.zero)
        
        precondition(pixelBufferAdaptor.pixelBufferPool != nil, "nil pixelBufferPool")
    }
    
    func render(appendPixelBuffers: @escaping (VideoWriter) -> Bool, completion: @escaping () -> Void) {
        
        precondition(videoWriter != nil, "Call start() to initialze the writer")
        
        let queue = DispatchQueue(label: "mediaInputQueue")
        
        videoWriterInput.requestMediaDataWhenReady(on: queue) {
            
            let isFinished = appendPixelBuffers(self)
            
            if isFinished {
                
                self.videoWriterInput.markAsFinished()
                
                self.videoWriter.finishWriting {
                    
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            } 
        }
    }
    
    func addImage(image: UIImage, withPresentationTime presentationTime: CMTime) -> Bool {
        
        precondition(pixelBufferAdaptor != nil, "Call start() to initialze the writer")
        
        let pixelBuffer = VideoWriter.pixelBufferFromImage(image: image,
                                                           pixelBufferPool: pixelBufferAdaptor.pixelBufferPool!,
                                                           size: renderSettings.size)
        
        return pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime)
    }
    
}

class ImageAnimator {
    
    static let kTimescale: Int32 = 600
    
    let settings: RenderSettings
    
    let videoWriter: VideoWriter
    
    var images: [UIImage]!
    
    var frameNum = 0
    
    var tempUrl = ""
    
    weak var delegate: MovieUrlProviderDelegate?
    
    class func removeFileAtURL(fileURL: NSURL) {
        
        do {
            
            try FileManager.default.removeItem(atPath: fileURL.path!)
            
        } catch _ as NSError {
            //
        }
    }
    
    init(renderSettings: RenderSettings, imageArray: [UIImage]) {
        settings = renderSettings
        videoWriter = VideoWriter(renderSettings: settings)
        images = imageArray
    }
    
    func render(completion: @escaping () -> Void) {
        
        // The VideoWriter will fail if a file exists at the URL, so clear it out first.
        ImageAnimator.removeFileAtURL(fileURL: settings.outputURL)
        
        videoWriter.start()
        
        videoWriter.render(appendPixelBuffers: appendPixelBuffers) {
            
            let path: String = self.settings.outputURL.path!
            
            self.tempUrl = path
            
            self.delegate?.provider(self, didGet: self.tempUrl)
            
            completion()
        }
        
    }
    
    func appendPixelBuffers(writer: VideoWriter) -> Bool {
        
        let frameDuration = CMTimeMake(value: Int64(ImageAnimator.kTimescale / settings.fps),
                                       timescale: ImageAnimator.kTimescale)
        
        while !images.isEmpty {
            
            if writer.isReadyForData == false {
                
                return false
            }
            
            let image = images.removeFirst()
            
            let presentationTime = CMTimeMultiply(frameDuration, multiplier: Int32(frameNum))
            
            let success = videoWriter.addImage(image: image, withPresentationTime: presentationTime)
            
            if success == false {
                
                fatalError("addImage() failed")
            }
            
            frameNum += 1
        }
        return true
    }
}
