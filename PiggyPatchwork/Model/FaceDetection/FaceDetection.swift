//
//  FaceDetection.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/10/2.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit
import Vision

protocol FaceDetectionDelegate: AnyObject {
    
    func faceDetecter(_ detecter: FaceDetection, didGet frames: [VNFaceObservation])
}

class FaceDetection {
    
    weak var delegate: FaceDetectionDelegate?
    
    func faceDetection(detect image: UIImage?) {
        
        let detectRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handleFaces)
        
        guard let image = image?.cgImage else { return }
        
        let detectRequestHandler = VNImageRequestHandler(cgImage: image,
                                                         options: [ : ])
        
        do {
            try detectRequestHandler.perform([detectRequest])
        } catch {
            
            PiggyJonAlert.showCustomIcon(icon: UIImage.asset(.exclamation_mark),
                                         message: "人臉偵測錯誤 (つд⊂)")
        }
    }
    
    func handleFaces(request: VNRequest, error: Error?) {
        
        guard
            let faceDetectResults = request.results as? [VNFaceObservation]
            else {
                fatalError("Unexpected result type from VNDetectFaceRetanglesRequest.")
        }
        
        if faceDetectResults.count == 0 {
            
            PiggyJonAlert.showCustomIcon(icon: UIImage.asset(.exclamation_mark),
                                         message: "這張照片偵測不到人臉 இдஇ")
            return
        }
        
        delegate?.faceDetecter(self, didGet: faceDetectResults)
    }
}
