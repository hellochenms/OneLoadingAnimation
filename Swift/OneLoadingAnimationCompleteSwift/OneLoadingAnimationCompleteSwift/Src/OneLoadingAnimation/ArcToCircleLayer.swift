//
//  ArcToCircleLayer.swift
//  OneLoadingAnimationCompleteSwift
//
//  Created by thatsoul on 15/12/13.
//  Copyright © 2015年 chenms.m2. All rights reserved.
//

import UIKit

class ArcToCircleLayer: CALayer {
    // MARK: - property
    var lineWidth: NSNumber?
    var color: UIColor?
    var progress: NSNumber? = 0

    // MARK: - override
    override class func needsDisplayForKey(key: String) -> Bool{
        switch key {
        case "lineWidth", "color", "progress":
            return true
        default:
            break
        }

        return super.needsDisplayForKey(key)
    }

    // 这个方法是CA系统调用的，比如创建presentationLayer时，看上去自定义的属性值要手动赋值。
    override init(layer: AnyObject) {
        super.init(layer: layer) // TODO: 这个位置对吗？

        let theLayer: ArcToCircleLayer = layer as! ArcToCircleLayer
        self.progress = theLayer.progress
        self.color = theLayer.color
        self.lineWidth = theLayer.lineWidth

//        print("layer: \(layer) self: \(self)") // 打开这一句，看看log很有趣
    }

    // 看上去，如果override init(layer: AnyObject)，必须 override init() 和 init?(coder aDecoder: NSCoder)
    override init() {
        super.init() // TODO: 这样OK吗？
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder) // TODO: 这样OK吗？
    }

    override func drawInContext(ctx: CGContext) {
//        print("lineWidth: \(lineWidth) color: \(color)")
        if lineWidth == nil || color == nil {
            return
        }

        let path = UIBezierPath()

        let radius = min(CGRectGetWidth(bounds), CGRectGetHeight(bounds)) / 2 - CGFloat(lineWidth!.doubleValue) / 2
        let center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))

        // O
        let originStart = M_PI * 7 / 2
        let originEnd = M_PI * 2
        let currentOrigin = originStart - (originStart - originEnd) * (progress?.doubleValue)!

        // D
        let destStart = M_PI * 3
        let destEnd = 0.0
        let currentDest = destStart - (destStart - destEnd) * (progress?.doubleValue)!

        path.addArcWithCenter(center, radius: radius, startAngle: CGFloat(currentOrigin), endAngle: CGFloat(currentDest), clockwise: false)

        CGContextAddPath(ctx, path.CGPath)
        CGContextSetLineWidth(ctx, CGFloat(lineWidth!.doubleValue))

        CGContextSetStrokeColorWithColor(ctx, color!.CGColor)
        CGContextStrokePath(ctx)
    }
}
