//
//  OneLoadingAnimation.m
//  OneLoadingAnimationStep1
//
//  Created by thatsoul on 15/11/15.
//  Copyright © 2015年 chenms.m2. All rights reserved.
//

#import "OneLoadingAnimationView.h"
#import "ArcToCircleLayer.h"

static CGFloat const kRadius = 40;
static CGFloat const kLineWidth = 6;
static CGFloat const kStep1Duration = 2;

@interface OneLoadingAnimationView ()
@property (nonatomic) CAShapeLayer *arcToCircleLayer;
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
}

- (void)doStep1 {
    self.arcToCircleLayer = [CAShapeLayer layer];
    self.arcToCircleLayer.bounds = CGRectMake(0, 0, kRadius * 2 + kLineWidth, kRadius * 2 + kLineWidth);
    self.arcToCircleLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint point = CGPointMake(CGRectGetMidX(self.arcToCircleLayer.bounds), CGRectGetMidY(self.arcToCircleLayer.bounds));
    [path addArcWithCenter:point radius:kRadius startAngle:0 endAngle:M_PI * 2 clockwise:NO];
    self.arcToCircleLayer.path = path.CGPath;
    self.arcToCircleLayer.lineWidth = kLineWidth;
    self.arcToCircleLayer.strokeColor = [UIColor blueColor].CGColor;
    self.arcToCircleLayer.fillColor = nil;

    [self.layer addSublayer:self.arcToCircleLayer];

    // end status
    // SS(strokeStart)
    CGFloat SSFrom = 0.25;
    CGFloat SSTo = 0;

    // SE(strokeEnd)
    CGFloat SEFrom = 0.5;
    CGFloat SETo = 1.0;

    // transform status
    self.arcToCircleLayer.transform = CATransform3DIdentity;

    // animation
    CABasicAnimation *ssAnima = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    ssAnima.fromValue = @(SSFrom);
    ssAnima.toValue = @(SSTo);

    CABasicAnimation *seAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    seAnima.fromValue = @(SEFrom);
    seAnima.toValue = @(SETo);

    CABasicAnimation *rotateAnima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnima.fromValue = @0;
    rotateAnima.toValue = @(-M_PI * 2);

    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[ssAnima, seAnima, rotateAnima];
    animation.duration = kStep1Duration;
    [self.arcToCircleLayer addAnimation:animation forKey:nil];
}

@end
