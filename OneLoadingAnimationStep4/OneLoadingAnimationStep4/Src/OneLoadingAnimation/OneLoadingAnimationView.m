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
static CGFloat const kStep2Duration = 0.5;
static CGFloat const kStep3Duration = 0.15;
static CGFloat const kStep4Duration = 5.0;
static CGFloat const kVerticalMoveLayerHeight = 15;
static CGFloat const kVerticalThinLayerWidth = 3;
static CGFloat const kYScale = 0.8;
static CGFloat const kVerticalFatLayerWidth = 6;

@interface OneLoadingAnimationView ()
@property (nonatomic) ArcToCircleLayer *arcToCircleLayer;
@property (nonatomic) CAShapeLayer *moveArcLayer;
@property (nonatomic) CALayer *verticalMoveLayer;
@property (nonatomic) CAShapeLayer *verticalDisappearLayer;
@property (nonatomic) CAShapeLayer *verticalAppearLayer;
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
    [self.verticalMoveLayer removeFromSuperlayer];
    [self.verticalDisappearLayer removeFromSuperlayer];
    [self.verticalAppearLayer removeFromSuperlayer];
}

// 第1阶段
- (void)doStep1 {
    self.arcToCircleLayer = [ArcToCircleLayer layer];
    self.arcToCircleLayer.color = [UIColor lightGrayColor];
    self.arcToCircleLayer.lineWidth = kLineWidth;
    [self.layer addSublayer:self.arcToCircleLayer];

    self.arcToCircleLayer.bounds = CGRectMake(0, 0, kRadius * 2 + kLineWidth, kRadius * 2 + kLineWidth);
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
    self.moveArcLayer.strokeColor = [UIColor lightGrayColor].CGColor;
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
    step2.delegate = self;
    [step2 setValue:@"step2" forKey:kName];
    step2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

    [self.moveArcLayer addAnimation:step2 forKey:nil];
}

// 第3阶段
- (void)doStep3 {
    // remove not useful
    [self.moveArcLayer removeFromSuperlayer];

    // step3 layer
    self.verticalMoveLayer = [CALayer layer];
    [self.layer addSublayer:self.verticalMoveLayer];

    CGFloat height = kVerticalMoveLayerHeight;
    self.verticalMoveLayer.bounds = CGRectMake(0, 0, kVerticalThinLayerWidth, height);
    self.verticalMoveLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) - kRadius * 2 + height / 2);
    self.verticalMoveLayer.backgroundColor = [UIColor lightGrayColor].CGColor;

    // position
    CGPoint originPosition = self.verticalMoveLayer.position;
    CGPoint destPosition = CGPointMake(originPosition.x,  CGRectGetMidY(self.bounds) - kRadius - height / 2);

    // end status
    self.verticalMoveLayer.position = destPosition;

    // animation
    CABasicAnimation *step3 = [CABasicAnimation animationWithKeyPath:@"position.y"];
    step3.fromValue = @(originPosition.y);
    step3.toValue = @(destPosition.y);
    step3.duration = kStep3Duration;
    step3.delegate = self;
    [step3 setValue:@"step3" forKey:kName];
    [self.verticalMoveLayer addAnimation:step3 forKey:nil];
}

// 第4阶段
- (void)doStep4 {
    [self doStep4a];
    [self doStep4b];
    [self doStep4c];
}
// 4阶段a：小圆变形
- (void)doStep4a {
    CGPoint position = self.arcToCircleLayer.position;
    self.arcToCircleLayer.anchorPoint = CGPointMake(0.5, 1);
    self.arcToCircleLayer.position = CGPointMake(position.x, position.y + kRadius + kLineWidth / 2);
    self.arcToCircleLayer.color = [UIColor redColor];

    // y scale
    CGFloat yFromScale = 1.0;
    CGFloat yToScale = kYScale;

    // x scale
    CGFloat xFromScale = 1.0;
    CGFloat xToScale = 1.1;

    // end status
    self.arcToCircleLayer.transform = CATransform3DMakeScale(xToScale, yToScale, 1);

    // animation
    CABasicAnimation *yAnima = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    yAnima.fromValue = @(yFromScale);
    yAnima.toValue = @(yToScale);

    CABasicAnimation *xAnima = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    xAnima.fromValue = @(xFromScale);
    xAnima.toValue = @(xToScale);

    CAAnimationGroup *anima = [CAAnimationGroup animation];
    anima.animations = @[yAnima, xAnima];
    anima.duration = kStep4Duration;
    anima.delegate = self;
    [anima setValue:@"step4" forKey:@"name"];

    [self.arcToCircleLayer addAnimation:anima forKey:nil];
}

// 4阶段b：逐渐消失的竖线
- (void)doStep4b {
    // remove
    [self.verticalMoveLayer removeFromSuperlayer];

    // new
    self.verticalDisappearLayer = [CAShapeLayer layer];
    self.verticalDisappearLayer.frame = self.bounds;
    [self.layer addSublayer:self.verticalDisappearLayer];

    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat height = kVerticalMoveLayerHeight;
    CGFloat originY = CGRectGetMidY(self.bounds) - kRadius - height;
    CGFloat pathHeight = height + kRadius * 2 * (1 - kYScale);
    CGFloat destY = originY + pathHeight;
    [path moveToPoint:CGPointMake(CGRectGetMidX(self.bounds), originY)];
    [path addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds), destY)];
    self.verticalDisappearLayer.path = path.CGPath;
    self.verticalDisappearLayer.lineWidth = kVerticalThinLayerWidth;
    self.verticalDisappearLayer.strokeColor = [UIColor greenColor].CGColor;
    self.verticalDisappearLayer.fillColor = nil;

    // SS(strokeStart)
    CGFloat SSFrom = 0;
    CGFloat SSTo = 1.0;

    // SE(strokeEnd)
    CGFloat SEFrom = height / pathHeight;
    CGFloat SETo = 1.0;

    // end status
    self.verticalDisappearLayer.strokeStart = SSTo;
    self.verticalDisappearLayer.strokeEnd = SETo;

    // animation
    CABasicAnimation *startAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startAnimation.fromValue = @(SSFrom);
    startAnimation.toValue = @(SSTo);

    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimation.fromValue = @(SEFrom);
    endAnimation.toValue = @(SETo);

    CAAnimationGroup *anima = [CAAnimationGroup animation];
    anima.animations = @[startAnimation, endAnimation];
    anima.duration = kStep4Duration;
    [self.verticalDisappearLayer addAnimation:anima forKey:nil];
}

// 4阶段c：逐渐出现的竖线
- (void)doStep4c {
    self.verticalAppearLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.verticalAppearLayer];
    self.verticalAppearLayer.frame = self.bounds;

    UIBezierPath *step4cPath = [UIBezierPath bezierPath];
    CGFloat originY = CGRectGetMidY(self.bounds) - kRadius;
    CGFloat destY = CGRectGetMidY(self.bounds) + kRadius;
    [step4cPath moveToPoint:CGPointMake(CGRectGetMidX(self.bounds), originY)];
    [step4cPath addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds), destY)];
    self.verticalAppearLayer.path = step4cPath.CGPath;
    self.verticalAppearLayer.lineWidth = kVerticalFatLayerWidth;
    self.verticalAppearLayer.strokeColor = [UIColor blueColor].CGColor;
    self.verticalAppearLayer.fillColor = nil;


    // SS(strokeStart)
    CGFloat SSFrom = 0;
    CGFloat SSTo = 1 - kYScale;

    // SE(strokeEnd)
    CGFloat SEFrom = 0;
    CGFloat SETo = 0.5;

    // end status
    self.verticalAppearLayer.strokeStart = SSTo;
    self.verticalAppearLayer.strokeEnd = SETo;

    // animation
    CABasicAnimation *startAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startAnimation.fromValue = @(SSFrom);
    startAnimation.toValue = @(SSTo);

    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimation.fromValue = @(SEFrom);
    endAnimation.toValue = @(SETo);

    CAAnimationGroup *anima = [CAAnimationGroup animation];
    anima.animations = @[startAnimation, endAnimation];
    anima.duration = kStep4Duration;
    [self.verticalAppearLayer addAnimation:anima forKey:nil];

}

#pragma mark - animation step stop
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:kName] isEqualToString:@"step1"]) {
        [self doStep2];
    } else if ([[anim valueForKey:kName] isEqualToString:@"step2"]) {
        [self doStep3];
    } else if ([[anim valueForKey:kName] isEqualToString:@"step3"]) {
        [self doStep4];
    }
}


@end
