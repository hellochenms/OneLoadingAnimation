//
//  OneLoadingAnimationView.swift
//  OneLoadingAnimationCompleteSwift
//
//  Created by thatsoul on 15/12/13.
//  Copyright © 2015年 chenms.m2. All rights reserved.
//

import UIKit

class OneLoadingAnimationView: UIView {
    // MARK: property
    let kName = "name"

    let kStep1Duration = 1.0
    let kStep2Duration = 0.5
    let kStep3Duration = 0.15
    let kStep4Duration = 0.25
    let kStep5Duration = 0.5
    let kBeforeStep6SuccessDelay = 0.1
    let kStep6SuccessDuration = 1.0
    let kStep6FailDuration = 0.5
    let kStep7FailDuration = 0.1

    let kRadius: CGFloat = 40.0
    let kLineWidth: CGFloat = 6.0
    let kVerticalMoveLayerHeight: CGFloat = 15.0
    let kVerticalThinLayerWidth: CGFloat = 3.0
    let kYScale: CGFloat = 0.8
    let kVerticalFatLayerWidth: CGFloat = 6.0

    var isSuccess: Bool?

    var arcToCircleLayer: ArcToCircleLayer?
    var moveArcLayer: CAShapeLayer?
    var verticalMoveLayer: CALayer?
    var verticalDisappearLayer: CAShapeLayer?
    var verticalAppearLayer: CAShapeLayer?
    var leftAppearLayer: CAShapeLayer?
    var rightAppearLayer: CAShapeLayer?
    var checkMarkLayer: CAShapeLayer?
    var exclamationMarkTopLayer: CAShapeLayer?
    var exclamationMarkBottomLayer: CAShapeLayer?

    var likeBlackColor: UIColor?
    var likeGreenColor: UIColor?
    var likeRedColor: UIColor?

    // MARK: - life cycle
    override func awakeFromNib() {
        super.awakeFromNib()

        likeBlackColor = UIColor(red: 0x46/255.0, green: 0x4d/255.0, blue: 0x65/255.0, alpha: 1.0)
        likeGreenColor = UIColor(red: 0x32/255.0, green: 0xa9/255.0, blue: 0x82/255.0, alpha: 1.0)
        likeRedColor = UIColor(red: 0xff/255.0, green: 0x61/255.0, blue: 0x51/255.0, alpha: 1.0)
    }

    // MARK: - public
    func startSuccess() {
        reset()
        isSuccess = true
        doStep1()
    }

    func startFail() {
        reset()
        isSuccess = false
        doStep1()
    }

    // MARK: - reset
    func reset() {
        arcToCircleLayer?.removeFromSuperlayer()
        moveArcLayer?.removeFromSuperlayer()
        verticalMoveLayer?.removeFromSuperlayer()
        verticalDisappearLayer?.removeFromSuperlayer()
        verticalAppearLayer?.removeFromSuperlayer()
        leftAppearLayer?.removeFromSuperlayer()
        rightAppearLayer?.removeFromSuperlayer()
        checkMarkLayer?.removeFromSuperlayer()
        exclamationMarkTopLayer?.removeFromSuperlayer()
        exclamationMarkBottomLayer?.removeFromSuperlayer()
        self.layer.removeAllAnimations()
    }

    // MARK: - step1
    func doStep1() {
        arcToCircleLayer = ArcToCircleLayer()
        arcToCircleLayer!.bounds = CGRectMake(0, 0, kRadius * 2 + kLineWidth, kRadius * 2 + kLineWidth)
        arcToCircleLayer!.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        arcToCircleLayer!.contentsScale = UIScreen.mainScreen().scale
        arcToCircleLayer!.color = likeBlackColor
        arcToCircleLayer!.lineWidth = NSNumber(double: Double(kLineWidth))
        self.layer.addSublayer(arcToCircleLayer!)

        // end status
        arcToCircleLayer!.progress = NSNumber(double: 1.0)

        // animation
        let animation = CABasicAnimation(keyPath: "progress")
        animation.duration = kStep1Duration
        animation.fromValue = NSNumber(double: 0.0)
        animation.toValue = NSNumber(double: 1.0)
        animation.delegate = self
        animation.setValue("step1", forKey: kName)
        arcToCircleLayer!.addAnimation(animation, forKey: nil)
    }

    // MARK: - step2
    func doStep2() {
        moveArcLayer = CAShapeLayer()
        self.layer.addSublayer(moveArcLayer!)
        moveArcLayer!.frame = self.layer.bounds

        // 弧的path
        let moveArcPath = UIBezierPath()
        // 小圆圆心
        let center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        // d（x轴上弧圆心与小圆左边缘的距离）
        let d: CGFloat = kRadius / 2
        // 弧圆心
        let arcCenter = CGPointMake(center.x - kRadius - d, center.y)
        // 弧半径
        let arcRadius: CGFloat = kRadius * 2 + d
        // O(origin)
        let origin: CGFloat = CGFloat(M_PI * 2.0)
        // D(dest)
        let dest: CGFloat = CGFloat(M_PI) * 2 - asin(kRadius * 2 / arcRadius)
        moveArcPath.addArcWithCenter(arcCenter, radius: arcRadius, startAngle: origin, endAngle: dest, clockwise: false)

        moveArcLayer!.path = moveArcPath.CGPath;
        moveArcLayer!.lineWidth = 3;
        moveArcLayer!.strokeColor = likeBlackColor!.CGColor;
        moveArcLayer!.fillColor = nil;

        // SS(strokeStart)
        let SSFrom: CGFloat  = 0.0
        let SSTo: CGFloat = 0.9

        // SE(strokeEnd)
        let SEFrom: CGFloat = 0.1
        let SETo: CGFloat = 1.0

        // end status
        moveArcLayer!.strokeStart = SSTo
        moveArcLayer!.strokeEnd = SETo

        // animation
        let startAnimation = CABasicAnimation(keyPath: "strokeStart")
        startAnimation.fromValue = SSFrom
        startAnimation.toValue = SSTo

        let endAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endAnimation.fromValue = SEFrom
        endAnimation.toValue = SETo

        let animation = CAAnimationGroup()
        animation.animations = [startAnimation, endAnimation]
        animation.duration = kStep2Duration
        animation.delegate = self
        animation.setValue("step2", forKey: kName)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        moveArcLayer!.addAnimation(animation, forKey: nil)
    }

    // MARK: - step3
    func doStep3() {
        // prepare for step3
        moveArcLayer?.removeFromSuperlayer();

        // step3 layer
        verticalMoveLayer = CALayer()
        verticalMoveLayer!.contentsScale = UIScreen.mainScreen().scale
        self.layer.addSublayer(verticalMoveLayer!)

        let height: CGFloat = kVerticalMoveLayerHeight;
        verticalMoveLayer!.bounds = CGRectMake(0, 0, kVerticalThinLayerWidth, height);
        verticalMoveLayer!.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) - kRadius * 2 + height / 2);
        verticalMoveLayer!.backgroundColor = likeBlackColor!.CGColor;

        // position
        let originPosition = verticalMoveLayer!.position;
        let destPosition = CGPointMake(originPosition.x,  CGRectGetMidY(self.bounds) - kRadius - height / 2);

        // end status
        verticalMoveLayer!.position = destPosition;

        // animation
        let step3 = CABasicAnimation(keyPath: "position.y")
        step3.fromValue = originPosition.y
        step3.toValue = destPosition.y
        step3.duration = kStep3Duration
        step3.delegate = self;
        step3.setValue("step3", forKey: kName)
        verticalMoveLayer!.addAnimation(step3, forKey: nil)
    }

    // MARK: - step4
    func doStep4() {
        prepareForStep4()
        doStep4a()
        doStep4b()
        doStep4c()
    }

    func prepareForStep4() {
        verticalMoveLayer?.removeFromSuperlayer()
    }

    // 4阶段a：小圆变形
    func doStep4a() {
        let frame = arcToCircleLayer!.frame
        arcToCircleLayer!.anchorPoint = CGPointMake(0.5, 1);
        arcToCircleLayer!.frame = frame

        // y scale
        let yFromScale: CGFloat = 1.0;
        let yToScale: CGFloat = kYScale;

        // x scale
        let xFromScale: CGFloat = 1.0;
        let xToScale: CGFloat = 1.1;

        // end status
        arcToCircleLayer!.transform = CATransform3DMakeScale(xToScale, yToScale, 1);

        // animation
        let yAnima = CABasicAnimation(keyPath: "transform.scale.y")
        yAnima.fromValue = yFromScale
        yAnima.toValue = yToScale

        let xAnima = CABasicAnimation(keyPath: "transform.scale.x")
        xAnima.fromValue = xFromScale
        xAnima.toValue = xToScale

        let anima = CAAnimationGroup()
        anima.animations = [yAnima, xAnima]
        anima.duration = kStep4Duration;
        anima.delegate = self;
        anima.setValue("step4", forKey: kName)

        arcToCircleLayer!.addAnimation(anima, forKey: nil)
    }

    // 4阶段b：逐渐消失的细线
    func doStep4b() {
        verticalDisappearLayer = CAShapeLayer()
        verticalDisappearLayer!.frame = self.bounds;
        self.layer.addSublayer(verticalDisappearLayer!)

        let path = UIBezierPath()
        let height: CGFloat = kVerticalMoveLayerHeight;
        let originY: CGFloat = CGRectGetMidY(self.bounds) - kRadius - height;
        let pathHeight: CGFloat = height + kRadius * 2 * (1 - kYScale);
        let destY: CGFloat = originY + pathHeight;
        path.moveToPoint(CGPointMake(CGRectGetMidX(self.bounds), originY))
        path.addLineToPoint(CGPointMake(CGRectGetMidX(self.bounds), destY))
        verticalDisappearLayer!.path = path.CGPath;
        verticalDisappearLayer!.lineWidth = kVerticalThinLayerWidth;
        verticalDisappearLayer!.strokeColor = likeBlackColor!.CGColor;
        verticalDisappearLayer!.fillColor = nil;

        // SS(strokeStart)
        let SSFrom: CGFloat = 0;
        let SSTo: CGFloat = 1.0;

        // SE(strokeEnd)
        let SEFrom: CGFloat = height / pathHeight;
        let SETo: CGFloat = 1.0;

        // end status
        verticalDisappearLayer!.strokeStart = SSTo;
        verticalDisappearLayer!.strokeEnd = SETo;

        // animation
        let startAnimation = CABasicAnimation(keyPath: "strokeStart")
        startAnimation.fromValue = SSFrom
        startAnimation.toValue = SSTo

        let endAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endAnimation.fromValue = SEFrom
        endAnimation.toValue = SETo

        let anima = CAAnimationGroup()
        anima.animations = [startAnimation, endAnimation];
        anima.duration = kStep4Duration;

        verticalDisappearLayer!.addAnimation(anima, forKey: nil)
    }

    // 4阶段c：逐渐出现的粗线
    func doStep4c() {
        verticalAppearLayer = CAShapeLayer()
        self.layer.addSublayer(verticalAppearLayer!)
        verticalAppearLayer!.frame = self.bounds

        let step4cPath = UIBezierPath()
        let originY: CGFloat = CGRectGetMidY(self.bounds) - kRadius;
        let destY: CGFloat = CGRectGetMidY(self.bounds) + kRadius;
        step4cPath.moveToPoint(CGPointMake(CGRectGetMidX(self.bounds), originY))
        step4cPath.addLineToPoint(CGPointMake(CGRectGetMidX(self.bounds), destY))
        verticalAppearLayer!.path = step4cPath.CGPath;
        verticalAppearLayer!.lineWidth = kVerticalFatLayerWidth;
        verticalAppearLayer!.strokeColor = likeBlackColor!.CGColor;
        verticalAppearLayer!.fillColor = nil;

        // SS(strokeStart)
        let SSFrom: CGFloat = 0;
        let SSTo: CGFloat = 1 - kYScale;

        // SE(strokeEnd)
        let SEFrom: CGFloat = 0;
        let SETo: CGFloat = 0.5;

        // end status
        verticalAppearLayer!.strokeStart = SSTo;
        verticalAppearLayer!.strokeEnd = SETo;

        // animation
        let startAnimation = CABasicAnimation(keyPath: "strokeStart")
        startAnimation.fromValue = SSFrom
        startAnimation.toValue = SSTo

        let endAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endAnimation.fromValue = SEFrom
        endAnimation.toValue = SETo

        let animation = CAAnimationGroup()
        animation.animations = [startAnimation, endAnimation];
        animation.duration = kStep4Duration;

        verticalAppearLayer!.addAnimation(animation, forKey: nil)
    }


    // MARK: - step5
    func doStep5() {
        prepareForStep5()
        doStep5a()
        doStep5b()
        doStep5c()
        doStep5d()
    }

    func prepareForStep5() {
        verticalDisappearLayer?.removeFromSuperlayer()
    }

    // 小圆回复原状
    func doStep5a() {
        // end status
        arcToCircleLayer!.transform = CATransform3DIdentity;

        // animation
        let anima = CABasicAnimation(keyPath: "transform.scale.y")
        anima.duration = kStep5Duration
        anima.fromValue = kYScale
        anima.toValue = 1
        anima.delegate = self;
        anima.setValue("step5", forKey: kName)

        arcToCircleLayer!.addAnimation(anima, forKey: nil)
    }


    // 竖线成长到全长
    func doStep5b() {
        // SS(strokeStart)
        let SSFrom: CGFloat = 1 - kYScale;
        let SSTo: CGFloat = 0;

        // SE(strokeEnd)
        let SEFrom: CGFloat = 0.5;
        let SETo: CGFloat = 1;

        // end status
        verticalAppearLayer!.strokeStart = SSTo;
        verticalAppearLayer!.strokeEnd = SETo;

        // animation
        let startAnimation = CABasicAnimation(keyPath: "strokeStart")
        startAnimation.fromValue = SSFrom
        startAnimation.toValue = SSTo

        let endAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endAnimation.fromValue = SEFrom
        endAnimation.toValue = SETo

        let anima = CAAnimationGroup()
        anima.animations = [startAnimation, endAnimation];
        anima.duration = kStep5Duration;

        verticalAppearLayer!.addAnimation(anima, forKey: nil)
    }

    // 左下斜线成长到全长
    func doStep5c() {
        leftAppearLayer = CAShapeLayer()
        self.layer.addSublayer(leftAppearLayer!)

        let path = UIBezierPath()
        let originPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        path.moveToPoint(originPoint)
        let deltaX: CGFloat = kRadius * sin(CGFloat(M_PI) / 3);
        let deltaY: CGFloat = kRadius * cos(CGFloat(M_PI) / 3);
        var destPoint = originPoint;
        destPoint.x -= deltaX;
        destPoint.y += deltaY;
        path.addLineToPoint(destPoint)
        leftAppearLayer!.path = path.CGPath;
        leftAppearLayer!.lineWidth = kLineWidth;
        leftAppearLayer!.strokeColor = likeBlackColor!.CGColor;
        leftAppearLayer!.fillColor = nil;

        // end status
        let strokeEnd: CGFloat = 1;
        leftAppearLayer!.strokeEnd = strokeEnd;

        // animation
        let anima = CABasicAnimation(keyPath: "strokeEnd")
        anima.duration = kStep5Duration;
        anima.fromValue = 0;
        anima.toValue = strokeEnd
        leftAppearLayer!.addAnimation(anima, forKey: nil)
    }

    // 右下斜线成长到全长
    func doStep5d() {
        rightAppearLayer = CAShapeLayer()
        self.layer.addSublayer(rightAppearLayer!)

        let path = UIBezierPath()
        let originPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        path.moveToPoint(originPoint)
        let deltaX: CGFloat = kRadius * sin(CGFloat(M_PI) / 3);
        let deltaY: CGFloat = kRadius * cos(CGFloat(M_PI) / 3);
        var destPoint = originPoint;
        destPoint.x += deltaX;
        destPoint.y += deltaY;
        path.addLineToPoint(destPoint)
        rightAppearLayer!.path = path.CGPath;
        rightAppearLayer!.lineWidth = kLineWidth;
        rightAppearLayer!.strokeColor = likeBlackColor!.CGColor;
        rightAppearLayer!.fillColor = nil;

        // end status
        let strokeEnd: CGFloat = 1;

        // animation
        rightAppearLayer!.strokeEnd = strokeEnd;
        let anima = CABasicAnimation(keyPath: "strokeEnd")
        anima.duration = kStep5Duration;
        anima.fromValue = 0;
        anima.toValue = strokeEnd
        rightAppearLayer!.addAnimation(anima, forKey: nil)
    }

    // MARK: - step6 success
    func doStep6Success() {
        dispatch_after(3, dispatch_get_main_queue()) { () -> Void in // TODO:TODO:TODO:Bug!
            self.prepareForStep6Success()
            self.processStep6SuccessA()
            self.processStep6SuccessB()
        }
    }

    func prepareForStep6Success() {
        verticalAppearLayer?.removeFromSuperlayer()
        leftAppearLayer?.removeFromSuperlayer()
        rightAppearLayer?.removeFromSuperlayer()
    }

    // 圆变色
    func processStep6SuccessA() {
        arcToCircleLayer!.color = likeGreenColor;
        arcToCircleLayer!.setNeedsDisplay() // TODO:TODO:TODO:Bug!
    }

    // 对号出现
    func processStep6SuccessB() {
        checkMarkLayer = CAShapeLayer()
        checkMarkLayer!.frame = self.bounds;
        self.layer.addSublayer(checkMarkLayer!)

        let path = UIBezierPath()
        let centerPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        var firstPoint = centerPoint;
        firstPoint.x -= kRadius / 2;
        path.moveToPoint(firstPoint)
        var secondPoint = centerPoint;
        secondPoint.x -= kRadius / 8;
        secondPoint.y += kRadius / 2;
        path.addLineToPoint(secondPoint)
        var thirdPoint = centerPoint;
        thirdPoint.x += kRadius / 2;
        thirdPoint.y -= kRadius / 2;
        path.addLineToPoint(thirdPoint)

        checkMarkLayer!.path = path.CGPath;
        checkMarkLayer!.lineWidth = 6;
        checkMarkLayer!.strokeColor = likeGreenColor!.CGColor;
        checkMarkLayer!.fillColor = nil;

        // end status
        let strokeEnd: CGFloat = 1;
        checkMarkLayer!.strokeEnd = strokeEnd;

        // animation
        let step6bAnimation = CABasicAnimation(keyPath: "strokeEnd")
        step6bAnimation.duration = kStep6SuccessDuration;
        step6bAnimation.fromValue = 0;
        step6bAnimation.toValue = strokeEnd
        checkMarkLayer!.addAnimation(step6bAnimation, forKey: nil)
    }

    // MARK: - step6 fail
    func doStep6Fail() {
        prepareForStep6Fail()
        processStep6FailA()
        processStep6FailB()
        processStep6FailC()
    }

    func prepareForStep6Fail() {
        verticalMoveLayer?.removeFromSuperlayer()
    }

    // 圆变色
    func processStep6FailA() {
        arcToCircleLayer!.color = likeRedColor;
        arcToCircleLayer!.setNeedsDisplay() // TODO:TODO:TODO:Bug!
    }

    // 叹号上半部分出现
    func processStep6FailB() {
        exclamationMarkTopLayer = CAShapeLayer()
        exclamationMarkTopLayer!.frame = self.bounds;
        self.layer.addSublayer(exclamationMarkTopLayer!)

        let partLength: CGFloat = kRadius * 2 / 8;
        let pathPartCount: CGFloat = 5.0;
        let visualPathPartCount: CGFloat = 4.0;
        let path = UIBezierPath()
        let originY: CGFloat = CGRectGetMidY(self.bounds) - kRadius;
        let destY: CGFloat = originY + partLength * pathPartCount
        path.moveToPoint(CGPointMake(CGRectGetMidX(self.bounds), originY))
        path.addLineToPoint(CGPointMake(CGRectGetMidX(self.bounds), destY))
        exclamationMarkTopLayer!.path = path.CGPath;
        exclamationMarkTopLayer!.lineWidth = 6;
        exclamationMarkTopLayer!.strokeColor = likeRedColor!.CGColor;
        exclamationMarkTopLayer!.fillColor = nil;

        // end status
        let strokeStart: CGFloat = (pathPartCount - visualPathPartCount ) / pathPartCount;
        let strokeEnd: CGFloat = 1.0;
        exclamationMarkTopLayer!.strokeStart = strokeStart;
        exclamationMarkTopLayer!.strokeEnd = strokeEnd;

        // animation
        let startAnimation = CABasicAnimation(keyPath: "strokeStart")
        startAnimation.fromValue = 0;
        startAnimation.toValue = strokeStart

        let endAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endAnimation.fromValue = 0;
        endAnimation.toValue = strokeEnd

        let anima = CAAnimationGroup()
        anima.animations = [startAnimation, endAnimation];
        anima.duration = kStep6FailDuration;
        anima.delegate = self;
        anima.setValue("step6Fail", forKey: kName)
        
        exclamationMarkTopLayer!.addAnimation(anima, forKey: nil)
    }

    // 叹号下半部分出现
    func processStep6FailC() {
        exclamationMarkBottomLayer = CAShapeLayer()
        exclamationMarkBottomLayer!.frame = self.bounds;
        self.layer.addSublayer(exclamationMarkBottomLayer!)

        let partLength: CGFloat = kRadius * 2 / 8;
        let pathPartCount: CGFloat = 2.0;
        let visualPathPartCount: CGFloat = 1.0;

        exclamationMarkBottomLayer!.frame = self.bounds;
        let path = UIBezierPath()
        let originY: CGFloat = CGRectGetMidY(self.bounds) + kRadius;
        let destY: CGFloat = originY - partLength * pathPartCount;
        path.moveToPoint(CGPointMake(CGRectGetMidX(self.bounds), originY))
        path.addLineToPoint(CGPointMake(CGRectGetMidX(self.bounds), destY))
        exclamationMarkBottomLayer!.path = path.CGPath;
        exclamationMarkBottomLayer!.lineWidth = 6;
        exclamationMarkBottomLayer!.strokeColor = likeRedColor!.CGColor;
        exclamationMarkBottomLayer!.fillColor = nil;

        // end status
        let strokeStart: CGFloat = (pathPartCount - visualPathPartCount ) / pathPartCount;
        let strokeEnd: CGFloat = 1.0;
        exclamationMarkBottomLayer!.strokeStart = strokeStart;
        exclamationMarkBottomLayer!.strokeEnd = strokeEnd;

        // animation
        let startAnimation = CABasicAnimation(keyPath: "strokeStart")
        startAnimation.fromValue = 0;
        startAnimation.toValue = strokeStart

        let endAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endAnimation.fromValue = 0;
        endAnimation.toValue = strokeEnd

        let anima = CAAnimationGroup()
        anima.animations = [startAnimation, endAnimation];
        anima.duration = kStep6FailDuration;
        
        exclamationMarkBottomLayer!.addAnimation(anima, forKey: nil)
    }

    // MARK: - step7 fail
    func doStep7Fail() {
        let anima = CABasicAnimation(keyPath: "transform.rotation.z")
        anima.fromValue = -M_PI / 12
        anima.toValue = M_PI / 12
        anima.duration = kStep7FailDuration;
        anima.autoreverses = true;
        anima.repeatCount = 4;
        self.layer.addAnimation(anima, forKey: nil)
    }

    // MARK: - animation step stop
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        switch anim.valueForKey(kName) as! String {
        case "step1":
            doStep2()
        case "step2":
            doStep3()
        case "step3":
            if self.isSuccess! {
                self.doStep4()
            } else {
                self.doStep6Fail()
            }
        case "step4":
            doStep5()
        case "step5":
            doStep6Success()
        case "step6Fail":
            doStep7Fail()
        default:
            break
        }
    }
}
