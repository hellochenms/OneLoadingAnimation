//
//  CircleIrregularTransformLayer.swift
//  CircleIrregularTransformSwift
//
//  Created by thatsoul on 16/1/2.
//  Copyright © 2016年 chenms.m2. All rights reserved.
//

import UIKit

class CircleIrregularTransformLayer: CALayer {
    var progress: CGFloat = 0

    let radius: CGFloat = 80
    let lineWidth: CGFloat = 6.0
    let xScale: CGFloat = 1.2
    let yScale: CGFloat = 0.8
    let controlPointFactor: CGFloat = 1.8
    let pointRadius: CGFloat = 3.0

    // MARK: - init
    override init(layer: AnyObject) {
        super.init(layer: layer)

        let theLayer = layer as! CircleIrregularTransformLayer
        progress = theLayer.progress
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init() {
        super.init()
    }

    // MARK: - needsDisplayForKey
    override static func needsDisplayForKey(key: String) -> Bool {
        switch key {
        case "progress":
            return true
        default:
            break
        }

        return super.needsDisplayForKey(key)
    }

    // MARK: - draw
    override func drawInContext(ctx: CGContext) {
        let path = UIBezierPath()

        // 以底点为原点
        let bottom = CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidY(bounds) + radius)
        // 控制点偏移距离
        let controlOffsetDistance = radius / controlPointFactor

        // 各点变化系数
        let xFactor = 1 + (xScale - 1) * progress
        let yFactor = 1 - (1 - yScale) * progress
        // 顶点特殊的变化系数（破坏规则变形）
        let topYFactor = 1 - (1 - yScale) * progress * 1.5

        // 右上弧
        let origin0 = CGPointMake(bottom.x + radius * xFactor, bottom.y - radius * yFactor)
        let dest0 = CGPointMake(bottom.x, bottom.y - radius * 2 * topYFactor)
        let control0A = CGPointMake(origin0.x, origin0.y - controlOffsetDistance)
        let control0B = CGPointMake(dest0.x + controlOffsetDistance, bottom.y - radius * 2 * yFactor)
        path.moveToPoint(origin0)
        path.addCurveToPoint(dest0, controlPoint1: control0A, controlPoint2: control0B)

        // 左上弧
        let origin1 = dest0
        let dest1 = CGPointMake(bottom.x - radius * xFactor, bottom.y - radius * yFactor)
        let control1A = CGPointMake(origin1.x - controlOffsetDistance, bottom.y - radius * 2 * yFactor)
        let control1B = CGPointMake(dest1.x, dest1.y - controlOffsetDistance)
        path.addCurveToPoint(dest1, controlPoint1: control1A, controlPoint2: control1B)

        // 左下弧
        let origin2 = dest1
        let dest2 = bottom
        let control2A = CGPointMake(origin2.x, origin2.y + controlOffsetDistance)
        let control2B = CGPointMake(dest2.x - controlOffsetDistance, dest2.y)
        path.addCurveToPoint(dest2, controlPoint1: control2A, controlPoint2: control2B)

        // 右下弧
        let origin3 = dest2
        let dest3 = origin0
        let control3A = CGPointMake(origin3.x + controlOffsetDistance, origin3.y)
        let control3B = CGPointMake(dest3.x, dest3.y + controlOffsetDistance)
        path.addCurveToPoint(dest3, controlPoint1: control3A, controlPoint2: control3B)

        CGContextAddPath(ctx, path.CGPath)

        CGContextSetLineWidth(ctx, lineWidth)
        CGContextSetStrokeColorWithColor(ctx, UIColor.blueColor().CGColor)
        CGContextStrokePath(ctx)

        // 辅助点
        let pointsPath = UIBezierPath()

        addArcForPath(pointsPath, point: origin0)
        addArcForPath(pointsPath, point: control0A)
        addArcForPath(pointsPath, point: control0B)
        addArcForPath(pointsPath, point: dest0)

        addArcForPath(pointsPath, point: origin1)
        addArcForPath(pointsPath, point: control1A)
        addArcForPath(pointsPath, point: control1B)
        addArcForPath(pointsPath, point: dest1)

        addArcForPath(pointsPath, point: origin2)
        addArcForPath(pointsPath, point: control2A)
        addArcForPath(pointsPath, point: control2B)
        addArcForPath(pointsPath, point: dest2)

        addArcForPath(pointsPath, point: origin3)
        addArcForPath(pointsPath, point: control3A)
        addArcForPath(pointsPath, point: control3B)
        addArcForPath(pointsPath, point: dest3)

        CGContextAddPath(ctx, pointsPath.CGPath)

        CGContextSetFillColorWithColor(ctx, UIColor.redColor().CGColor)
        CGContextFillPath(ctx)

        // 辅助线
        let linePath = UIBezierPath()

        linePath.moveToPoint(origin0)
        linePath.addLineToPoint(control0A)
        linePath.addLineToPoint(control0B)
        linePath.addLineToPoint(dest0)

        linePath.addLineToPoint(origin1)
        linePath.addLineToPoint(control1A)
        linePath.addLineToPoint(control1B)
        linePath.addLineToPoint(dest1)

        linePath.addLineToPoint(origin2)
        linePath.addLineToPoint(control2A)
        linePath.addLineToPoint(control2B)
        linePath.addLineToPoint(dest2)

        linePath.addLineToPoint(origin3)
        linePath.addLineToPoint(control3A)
        linePath.addLineToPoint(control3B)
        linePath.addLineToPoint(dest3)
        
        CGContextAddPath(ctx, linePath.CGPath)
        
        CGContextSetLineWidth(ctx, 2)
        CGContextSetStrokeColorWithColor(ctx, UIColor.redColor().CGColor)
        CGContextStrokePath(ctx)
    }

    // MARK: - tools
    private func addArcForPath(path: UIBezierPath, point: CGPoint) {
        path.moveToPoint(point)
        path.addArcWithCenter(point, radius: pointRadius, startAngle: 0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
    }
}
