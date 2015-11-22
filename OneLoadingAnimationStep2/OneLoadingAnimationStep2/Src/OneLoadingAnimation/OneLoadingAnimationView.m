//
//  OneLoadingAnimation.m
//  OneLoadingAnimationStep1
//
//  Created by thatsoul on 15/11/15.
//  Copyright © 2015年 chenms.m2. All rights reserved.
//

#import "OneLoadingAnimationView.h"
#import "ArcToCircleLayer.h"

static NSString * const kName = @"name";

static CGFloat const kRadius = 40;
static CGFloat const kLineWidth = 6;
static CGFloat const kStep1Duration = 1.0;
static CGFloat const kStep2Duration = 3.0;

@interface OneLoadingAnimationView ()
@property (nonatomic) ArcToCircleLayer *arcToCircleLayer;
@property (nonatomic) CAShapeLayer *moveArcLayer;
@end

@implementation OneLoadingAnimationView

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - public
- (void)startAnimation {
    [self reset];
    [self doStep1];
}

#pragma mark - animation
- (void)reset {
    [self.arcToCircleLayer removeFromSuperlayer];
    [self.moveArcLayer removeFromSuperlayer];
}

// 第1阶段
- (void)doStep1 {
    self.arcToCircleLayer = [ArcToCircleLayer layer];
    [self.layer addSublayer:self.arcToCircleLayer];

    self.arcToCircleLayer.bounds = CGRectMake(0, 0, kRadius * 2 + kLineWidth, kRadius * 2 + kLineWidth);
    self.arcToCircleLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

    // animation
    self.arcToCircleLayer.progress = 1; // end status

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
    animation.duration = kStep1Duration;
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.delegate = self;
    [animation setValue:@"step1" forKey:kName];
    [self.arcToCircleLayer addAnimation:animation forKey:nil];
}

// 第2阶段
- (void)doStep2 {
    self.moveArcLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.moveArcLayer];
    self.moveArcLayer.frame = self.layer.bounds;
    // 弧的path
    UIBezierPath *moveArcPath = [UIBezierPath bezierPath];
    // 小圆圆心
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    // d（x轴上弧圆心与小圆左边缘的距离）
    CGFloat d = kRadius / 2;
    // 弧圆心
    CGPoint arcCenter = CGPointMake(center.x - kRadius - d, center.y);
    // 弧半径
    CGFloat arcRadius = kRadius * 2 + d;
    // O(origin)
    CGFloat origin = M_PI * 2;
    // D(dest)
    CGFloat dest = M_PI * 2 - asin(kRadius * 2 / arcRadius);
    [moveArcPath addArcWithCenter:arcCenter radius:arcRadius startAngle:origin endAngle:dest clockwise:NO];
    self.moveArcLayer.path = moveArcPath.CGPath;
    self.moveArcLayer.lineWidth = 3;
    self.moveArcLayer.strokeColor = [UIColor blueColor].CGColor;
    self.moveArcLayer.fillColor = nil;

    // SS(strokeStart)
    CGFloat SSFrom = 0;
    CGFloat SSTo = 0.9;

    // SE(strokeEnd)
    CGFloat SEFrom = 0.1;
    CGFloat SETo = 1;

    // end status
    self.moveArcLayer.strokeStart = SSTo;
    self.moveArcLayer.strokeEnd = SETo;

    // animation
    CABasicAnimation *startAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startAnimation.fromValue = @(SSFrom);
    startAnimation.toValue = @(SSTo);

    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimation.fromValue = @(SEFrom);
    endAnimation.toValue = @(SETo);

    CAAnimationGroup *step2 = [CAAnimationGroup animation];
    step2.animations = @[startAnimation, endAnimation];
    step2.duration = kStep2Duration;
    step2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

    [self.moveArcLayer addAnimation:step2 forKey:nil];
}

#pragma mark - animation step stop
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:kName] isEqualToString:@"step1"]) {
        [self doStep2];
    }
}

@end
