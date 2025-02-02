//
//  RecordButtonKit.swift
//  igetHappyAudioModule
//
//  Created by Harpreet Singh on 7/22/19.
//  Copyright © 2019 Harpreet Singh. All rights reserved.
//

import Foundation
import UIKit

public class RecordButtonKit : NSObject {
    
    //// Cache
    
    private struct Cache {
        static let recordButtonColor: UIColor = UIColor(red: 1.000, green: 0.000, blue: 0.000, alpha: 1.000)
        static let recordButtonHighlightedColor: UIColor = RecordButtonKit.recordButtonColor.withBrightness(0.3)
        static let recordFrameColor: UIColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        static let recordButtonNormalColor: UIColor = RecordButtonKit.recordButtonColor
    }
    
    //// Colors
    
    @objc public dynamic class var recordButtonColor: UIColor { return Cache.recordButtonColor }
    @objc public dynamic class var recordButtonHighlightedColor: UIColor { return Cache.recordButtonHighlightedColor }
    @objc public dynamic class var recordFrameColor: UIColor { return Cache.recordFrameColor }
    @objc public dynamic class var recordButtonNormalColor: UIColor { return Cache.recordButtonNormalColor }
    
    //// Drawing Methods
    
    @objc public dynamic class func drawRecordButton(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 100, height: 100), resizing: ResizingBehavior = .aspectFit, recordButtonFrameColor: UIColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000), isRecording: CGFloat = 1, isPressed: Bool = false) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 100, height: 100), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 100, y: resizedFrame.height / 100)
        
        
        
        //// Variable Declarations
        let radius: CGFloat = 10 + 37 * min(isRecording * 1.88, 1)
        let buttonScale: CGFloat = 1 - (1 - isRecording) * 0.45
        let buttonFillColor = isPressed ? RecordButtonKit.recordButtonHighlightedColor : RecordButtonKit.recordButtonNormalColor
        
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 4, y: 4, width: 92, height: 92))
        recordButtonFrameColor.setStroke()
        ovalPath.lineWidth = 8
        ovalPath.stroke()
        
        
        //// Rectangle Drawing
        context.saveGState()
        context.translateBy(x: 50, y: 50)
        context.scaleBy(x: buttonScale, y: buttonScale)
        
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: -39, y: -39, width: 78, height: 78), cornerRadius: radius)
        buttonFillColor.setFill()
        rectanglePath.fill()
        
        context.restoreGState()
        
        context.restoreGState()
        
    }
    
    //// Generated Images
    
    @objc public dynamic class func imageOfRecordButton(recordButtonFrameColor: UIColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000), isRecording: CGFloat = 1, isPressed: Bool = false) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 100, height: 100), false, 0)
        RecordButtonKit.drawRecordButton(recordButtonFrameColor: recordButtonFrameColor, isRecording: isRecording, isPressed: isPressed)
        
        let imageOfRecordButton = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return imageOfRecordButton
    }
    
    
    
    
    @objc public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.
        
        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }
            
            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)
            
            switch self {
            case .aspectFit:
                scales.width = min(scales.width, scales.height)
                scales.height = scales.width
            case .aspectFill:
                scales.width = max(scales.width, scales.height)
                scales.height = scales.width
            case .stretch:
                break
            case .center:
                scales.width = 1
                scales.height = 1
            }
            
            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}



extension UIColor {
    func withHue(_ newHue: CGFloat) -> UIColor {
        var saturation: CGFloat = 1, brightness: CGFloat = 1, alpha: CGFloat = 1
        self.getHue(nil, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: newHue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    func withSaturation(_ newSaturation: CGFloat) -> UIColor {
        var hue: CGFloat = 1, brightness: CGFloat = 1, alpha: CGFloat = 1
        self.getHue(&hue, saturation: nil, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: hue, saturation: newSaturation, brightness: brightness, alpha: alpha)
    }
    func withBrightness(_ newBrightness: CGFloat) -> UIColor {
        var hue: CGFloat = 1, saturation: CGFloat = 1, alpha: CGFloat = 1
        self.getHue(&hue, saturation: &saturation, brightness: nil, alpha: &alpha)
        return UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
    }
    func withAlpha(_ newAlpha: CGFloat) -> UIColor {
        var hue: CGFloat = 1, saturation: CGFloat = 1, brightness: CGFloat = 1
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: newAlpha)
    }
    func highlight(withLevel highlight: CGFloat) -> UIColor {
        var red: CGFloat = 1, green: CGFloat = 1, blue: CGFloat = 1, alpha: CGFloat = 1
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(red: red * (1-highlight) + highlight, green: green * (1-highlight) + highlight, blue: blue * (1-highlight) + highlight, alpha: alpha * (1-highlight) + highlight)
    }
    func shadow(withLevel shadow: CGFloat) -> UIColor {
        var red: CGFloat = 1, green: CGFloat = 1, blue: CGFloat = 1, alpha: CGFloat = 1
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(red: red * (1-shadow), green: green * (1-shadow), blue: blue * (1-shadow), alpha: alpha * (1-shadow) + shadow)
    }
}

