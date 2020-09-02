//
//  FaceView.swift
//  FaceApp
//
//  Created by Dayeon Jung on 2020/09/02.
//  Copyright © 2020 Dayeon Jung. All rights reserved.
//

import UIKit

class FaceView: UIView {

    var scale: CGFloat = 0.9
    var mouthCurvature: Double = 1.0 // -1 ~ 1
    
    private var skullRadius: CGFloat {
        return min(self.bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    private var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private struct Ratios {
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset: CGFloat = 3
    }
    
    private enum Eye {
        case Left
        case Right
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, widthRadius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: widthRadius,
            startAngle: 0.0,
            endAngle:
            CGFloat(2 * Double.pi),
            clockwise: false
        )
        path.lineWidth = 5.0
        return path
    }
    
    private func getEyeCenter(eye: Eye) -> CGPoint {
        let eyeOffset = self.skullRadius / Ratios.SkullRadiusToEyeOffset
        var eyeCenter = self.skullCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .Left:
            eyeCenter.x -= eyeOffset
        case .Right:
            eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    private func pathForEye(eye: Eye) -> UIBezierPath {
        let eyeRadius = skullRadius/Ratios.SkullRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye: eye)
        return pathForCircleCenteredAtPoint(midPoint: eyeCenter, widthRadius: eyeRadius)
    }
    
    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = self.skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthHeight = self.skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffset = self.skullRadius / Ratios.SkullRadiusToMouthOffset
        
        let mouthRect = CGRect(x: self.skullCenter.x - mouthWidth/2, y: self.skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width/3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width/3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = 5.0
        
        return path
    }
    
    override func draw(_ rect: CGRect) {
               
        UIColor.blue.set()
        pathForCircleCenteredAtPoint(midPoint: skullCenter, widthRadius: skullRadius).stroke()
        pathForEye(eye: .Left).stroke()
        pathForEye(eye: .Right).stroke()
        pathForMouth().stroke()
    }
   

}
