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
static CGFloat const kStep1Duration = 5.0;

@interface OneLoadingAnimationView ()
@property (nonatomic) ArcToCircleLayer *arcToCircleLayer;
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
    self.arcToCircleLayer = [ArcToCircleLayer layer];
    self.arcToCircleLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:self.arcToCircleLayer];

    self.arcToCircleLayer.bounds = CGRectMake(0, 0, kRadius * 2 + kLineWidth, kRadius * 2 + kLineWidth);
    self.arcToCircleLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

    // animation
    self.arcToCircleLayer.progress = 1; // end status

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
    animation.duration = kStep1Duration;
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    [self.arcToCircleLayer addAnimation:animation forKey:nil];
}

@end
