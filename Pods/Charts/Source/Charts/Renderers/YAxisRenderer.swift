//
//  YAxisRenderer.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics

@objc(ChartYAxisRenderer)
open class YAxisRenderer: AxisRendererBase
{
    @objc public init(viewPortHandler: ViewPortHandler, yAxis: YAxis?, transformer: Transformer?)
    {
        super.init(viewPortHandler: viewPortHandler, transformer: transformer, axis: yAxis)
    }
    
    /// draws the y-axis labels to the screen
    open override func renderAxisLabels(context: CGContext)
    {
        guard let yAxis = self.axis as? YAxis else { return }
        
        if !yAxis.isEnabled || !yAxis.isDrawLabelsEnabled
        {
            return
        }
        
        let xoffset = yAxis.xOffset
        let yoffset = yAxis.labelFont.lineHeight / 2.5 + yAxis.yOffset
        
        let dependency = yAxis.axisDependency
        let labelPosition = yAxis.labelPosition
        
        var xPos = CGFloat(0.0)
        
        var textAlign: NSTextAlignment
        
        if dependency == .left
        {
            if labelPosition == .outsideChart
            {
                textAlign = .right
                xPos = viewPortHandler.offsetLeft - xoffset
            }
            else
            {
                textAlign = .left
                xPos = viewPortHandler.offsetLeft + xoffset
            }
            
        }
        else
        {
            if labelPosition == .outsideChart
            {
                textAlign = .left
                xPos = viewPortHandler.contentRight + xoffset
            }
            else
            {
                textAlign = .right
                xPos = viewPortHandler.contentRight - xoffset
            }
        }
        
        drawYLabels(
            context: context,
            fixedPosition: xPos,
            positions: transformedPositions(),
            offset: yoffset - yAxis.labelFont.lineHeight,
            textAlign: textAlign)
    }
    
    open override func renderAxisLine(context: CGContext)
    {
        guard let yAxis = self.axis as? YAxis else { return }
        
        if !yAxis.isEnabled || !yAxis.drawAxisLineEnabled
        {
            return
        }
        
        context.saveGState()
        
        context.setStrokeColor(yAxis.axisLineColor.cgColor)
        context.setLineWidth(yAxis.axisLineWidth)
        if yAxis.axisLineDashLengths != nil
        {
            context.setLineDash(phase: yAxis.axisLineDashPhase, lengths: yAxis.axisLineDashLengths)
        }
        else
        {
            context.setLineDash(phase: 0.0, lengths: [])
        }
        
        if yAxis.axisDependency == .left
        {
            context.beginPath()
            context.move(to: CGPoint(x: viewPortHandler.contentLeft, y: viewPortHandler.contentTop))
            context.addLine(to: CGPoint(x: viewPortHandler.contentLeft, y: viewPortHandler.contentBottom))
            context.strokePath()
        }
        else
        {
            context.beginPath()
            context.move(to: CGPoint(x: viewPortHandler.contentRight, y: viewPortHandler.contentTop))
            context.addLine(to: CGPoint(x: viewPortHandler.contentRight, y: viewPortHandler.contentBottom))
            context.strokePath()
        }
        
        context.restoreGState()
    }
    
    /// draws the y-labels on the specified x-position
    //Gagan
    /// draws the y-labels on the specified x-position
    @objc internal func drawYLabels(
        context: CGContext,
        fixedPosition: CGFloat,
        positions: [CGPoint],
        offset: CGFloat,
        textAlign: NSTextAlignment)
    {
        guard
            let yAxis = self.axis as? YAxis
            else { return }
        
        let labelFont = yAxis.labelFont
        let labelTextColor = yAxis.labelTextColor
        
        let from = yAxis.isDrawBottomYLabelEntryEnabled ? 0 : 1
        let to = yAxis.isDrawTopYLabelEntryEnabled ? yAxis.entryCount : (yAxis.entryCount - 1)
       // var arrMoodsPlotGraph = ["happy","blushing","ic_angry_dark","ic_angry_dark","ic_angry_dark","ic_angry_dark"]
         var imageName = String()
        
        for i in stride(from: from, to: 6, by: 1)
        {
//            let text = yAxis.getFormattedLabel(i)
//            print(text)
//            let valueRange = Float32(text)
//
//            if valueRange! > 0.0 && valueRange! <= 1.0 {
//
//                  imageName  =  "Group-7"
//            } else if valueRange! >= 1.0 && valueRange! <= 2.0 {
//                imageName  =  "ic_big_grin"
//            }  else if valueRange! >= 2.0 && valueRange! <= 3.0 {
//                imageName  =  "Group"
//            }  else if valueRange! >= 3.0 && valueRange! <= 4.0{
//                imageName  =  "pocker_face"
//            } else if valueRange! >= 4.0 && valueRange! <= 5.0 {
//                imageName  =  "ic_angry_dark"
//            }else{
//             //   imageName  =  "Group-21"
//            }
            
            
           
            
            if i > 0 && i <= 1 {
                
                imageName  =  "Group-7"
            } else if i >= 1 && i <= 2 {
                imageName  =  "ic_big_grin"
            }  else if i >= 2 && i <= 3 {
                imageName  =  "Group"
            }  else if i >= 3 && i <= 4{
                imageName  =  "pocker_face"
            } else if i    >= 4 && i <= 5{
                imageName  =  "ic_angry_dark"
            }else{
                //   imageName  =  "Group-21"
            }
         
         //   if (i > arrMoodsPlotGraph.count){
          //       imageName  = "blushing"
           // }else{
              // let imageName  = arrMoodsPlotGraph[i]
         //   }
           
            
        //  let image  = NSUIImage.init(named: imageName)
            if (imageName != ""){
                 ChartUtils.drawImage(context: context, image: NSUIImage.init(named: imageName)!, x: fixedPosition - 10.0 , y: positions[i].y + offset + 5, size: CGSize.init(width: 20, height: 20))
            }
            
           
            
            
            //            ChartUtils.drawText(
            //                context: context,
            //                text: text,
            //                point: CGPoint(x: fixedPosition, y: positions[i].y + offset),
            //                align: textAlign,
            //                attributes: [NSAttributedStringKey.font: labelFont, NSAttributedStringKey.foregroundColor: labelTextColor])
        }
    }
    
    
    open override func renderGridLines(context: CGContext)
    {
        guard let
            yAxis = self.axis as? YAxis
            else { return }
        
        if !yAxis.isEnabled
        {
            return
        }
        
        if yAxis.drawGridLinesEnabled
        {
            let positions = transformedPositions()
            
            context.saveGState()
            defer { context.restoreGState() }
            context.clip(to: self.gridClippingRect)
            
            context.setShouldAntialias(yAxis.gridAntialiasEnabled)
            context.setStrokeColor(yAxis.gridColor.cgColor)
            context.setLineWidth(yAxis.gridLineWidth)
            context.setLineCap(yAxis.gridLineCap)
            
            if yAxis.gridLineDashLengths != nil
            {
                context.setLineDash(phase: yAxis.gridLineDashPhase, lengths: yAxis.gridLineDashLengths)
                
            }
            else
            {
                context.setLineDash(phase: 0.0, lengths: [])
            }
            
            // draw the grid
            positions.forEach { drawGridLine(context: context, position: $0) }
        }

        if yAxis.drawZeroLineEnabled
        {
            // draw zero line
            drawZeroLine(context: context)
        }
    }
    
    @objc open var gridClippingRect: CGRect
    {
        var contentRect = viewPortHandler.contentRect
        let dy = self.axis?.gridLineWidth ?? 0.0
        contentRect.origin.y -= dy / 2.0
        contentRect.size.height += dy
        return contentRect
    }
    
    @objc open func drawGridLine(
        context: CGContext,
        position: CGPoint)
    {
        context.beginPath()
        context.move(to: CGPoint(x: viewPortHandler.contentLeft, y: position.y))
        context.addLine(to: CGPoint(x: viewPortHandler.contentRight, y: position.y))
        context.strokePath()
    }
    
    @objc open func transformedPositions() -> [CGPoint]
    {
        guard
            let yAxis = self.axis as? YAxis,
            let transformer = self.transformer
            else { return [CGPoint]() }
        
        var positions = [CGPoint]()
        positions.reserveCapacity(yAxis.entryCount)
        
        let entries = yAxis.entries
        
        for i in stride(from: 0, to: yAxis.entryCount, by: 1)
        {
            positions.append(CGPoint(x: 0.0, y: entries[i]))
        }

        transformer.pointValuesToPixel(&positions)
        
        return positions
    }

    /// Draws the zero line at the specified position.
    @objc open func drawZeroLine(context: CGContext)
    {
        guard
            let yAxis = self.axis as? YAxis,
            let transformer = self.transformer,
            let zeroLineColor = yAxis.zeroLineColor
            else { return }
        
        context.saveGState()
        defer { context.restoreGState() }
        
        var clippingRect = viewPortHandler.contentRect
        clippingRect.origin.y -= yAxis.zeroLineWidth / 2.0
        clippingRect.size.height += yAxis.zeroLineWidth
        context.clip(to: clippingRect)

        context.setStrokeColor(zeroLineColor.cgColor)
        context.setLineWidth(yAxis.zeroLineWidth)
        
        let pos = transformer.pixelForValues(x: 0.0, y: 0.0)
    
        if yAxis.zeroLineDashLengths != nil
        {
            context.setLineDash(phase: yAxis.zeroLineDashPhase, lengths: yAxis.zeroLineDashLengths!)
        }
        else
        {
            context.setLineDash(phase: 0.0, lengths: [])
        }
        
        context.move(to: CGPoint(x: viewPortHandler.contentLeft, y: pos.y))
        context.addLine(to: CGPoint(x: viewPortHandler.contentRight, y: pos.y))
        context.drawPath(using: CGPathDrawingMode.stroke)
    }
    
    open override func renderLimitLines(context: CGContext)
    {
        guard
            let yAxis = self.axis as? YAxis,
            let transformer = self.transformer
            else { return }
        
        var limitLines = yAxis.limitLines
        
        if limitLines.count == 0
        {
            return
        }
        
        context.saveGState()
        
        let trans = transformer.valueToPixelMatrix
        
        var position = CGPoint(x: 0.0, y: 0.0)
        
        for i in 0 ..< limitLines.count
        {
            let l = limitLines[i]
            
            if !l.isEnabled
            {
                continue
            }
            
            context.saveGState()
            defer { context.restoreGState() }
            
            var clippingRect = viewPortHandler.contentRect
            clippingRect.origin.y -= l.lineWidth / 2.0
            clippingRect.size.height += l.lineWidth
            context.clip(to: clippingRect)
            
            position.x = 0.0
            position.y = CGFloat(l.limit)
            position = position.applying(trans)
            
            context.beginPath()
            context.move(to: CGPoint(x: viewPortHandler.contentLeft, y: position.y))
            context.addLine(to: CGPoint(x: viewPortHandler.contentRight, y: position.y))
            
            context.setStrokeColor(l.lineColor.cgColor)
            context.setLineWidth(l.lineWidth)
            if l.lineDashLengths != nil
            {
                context.setLineDash(phase: l.lineDashPhase, lengths: l.lineDashLengths!)
            }
            else
            {
                context.setLineDash(phase: 0.0, lengths: [])
            }
            
            context.strokePath()
            
            let label = l.label
            
            // if drawing the limit-value label is enabled
            if l.drawLabelEnabled && label.count > 0
            {
                let labelLineHeight = l.valueFont.lineHeight
                
                let xOffset: CGFloat = 4.0 + l.xOffset
                let yOffset: CGFloat = l.lineWidth + labelLineHeight + l.yOffset
                
                if l.labelPosition == .topRight
                {
                    ChartUtils.drawText(context: context,
                        text: label,
                        point: CGPoint(
                            x: viewPortHandler.contentRight - xOffset,
                            y: position.y - yOffset),
                        align: .right,
                        attributes: [NSAttributedString.Key.font: l.valueFont, NSAttributedString.Key.foregroundColor: l.valueTextColor])
                }
                else if l.labelPosition == .bottomRight
                {
                    ChartUtils.drawText(context: context,
                        text: label,
                        point: CGPoint(
                            x: viewPortHandler.contentRight - xOffset,
                            y: position.y + yOffset - labelLineHeight),
                        align: .right,
                        attributes: [NSAttributedString.Key.font: l.valueFont, NSAttributedString.Key.foregroundColor: l.valueTextColor])
                }
                else if l.labelPosition == .topLeft
                {
                    ChartUtils.drawText(context: context,
                        text: label,
                        point: CGPoint(
                            x: viewPortHandler.contentLeft + xOffset,
                            y: position.y - yOffset),
                        align: .left,
                        attributes: [NSAttributedString.Key.font: l.valueFont, NSAttributedString.Key.foregroundColor: l.valueTextColor])
                }
                else
                {
                    ChartUtils.drawText(context: context,
                        text: label,
                        point: CGPoint(
                            x: viewPortHandler.contentLeft + xOffset,
                            y: position.y + yOffset - labelLineHeight),
                        align: .left,
                        attributes: [NSAttributedString.Key.font: l.valueFont, NSAttributedString.Key.foregroundColor: l.valueTextColor])
                }
            }
        }
        
        context.restoreGState()
    }
}
