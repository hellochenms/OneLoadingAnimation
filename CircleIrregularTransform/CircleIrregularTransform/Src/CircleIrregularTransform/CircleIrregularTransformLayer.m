//
//  CircleIrregularTransformLayer.m
//  CircleIrregularTransform
//
//  Created by thatsoul on 15/12/6.
//  Copyright © 2015年 chenms.m2. All rights reserved.
//

#import "CircleIrregularTransformLayer.h"
#import <UIKit/UIKit.h>

static CGFloat const kLineWidth = 6;
static CGFloat const kYScale = 0.8;
static CGFloat const kXScale = 0.8;
static CGFloat const kControlPointFactor = 1.8;

@implementation CircleIrregularTransformLayer

@dynamic radius;
@dynamic progress;

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"radius"]) {
        return YES;
    } else if ([key isEqualToString:@"progress"]) {
        return YES;
    }

    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx {
    UIBezierPath *path = [UIBezierPath bezierPath];

    CGFloat radius = self.radius;
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

    // x轴上的偏移距离
    CGFloat xMoveOffsetDistance = radius * 2 * (1 - kXScale) / 2 * self.progress;
    // y轴上的偏移距离
    CGFloat yMoveOffsetDistance = radius * 2 * (1 - kYScale) / 2 * self.progress;
    // control点在对应轴上（x或y轴）到对应点（起点或终点）的偏移距离
    CGFloat controlOffsetDistance = radius / kControlPointFactor;

    // 右上弧
    CGPoint origin0 = CGPointMake(center.x + radius + xMoveOffsetDistance, center.y + yMoveOffsetDistance);
    CGPoint dest0 = CGPointMake(center.x, center.y - radius + yMoveOffsetDistance * 3);
    CGPoint control0A = CGPointMake(origin0.x, origin0.y - controlOffsetDistance);
    CGPoint control0B = CGPointMake(dest0.x + controlOffsetDistance, center.y - radius + yMoveOffsetDistance * 2);
    [path moveToPoint:origin0];
    [path addCurveToPoint:dest0 controlPoint1:control0A controlPoint2:control0B];

    // 左上弧
    CGPoint origin1 = dest0;
    CGPoint dest1 = CGPointMake(center.x - radius - xMoveOffsetDistance, center.y + yMoveOffsetDistance);
    CGPoint control1A = CGPointMake(origin1.x - controlOffsetDistance, center.y - radius + yMoveOffsetDistance * 2);
    CGPoint control1B = CGPointMake(dest1.x, dest1.y - controlOffsetDistance);
    [path addCurveToPoint:dest1 controlPoint1:control1A controlPoint2:control1B];

    // 左下弧
    CGPoint origin2 = dest1;
    CGPoint dest2 = CGPointMake(center.x, center.y + radius);
    CGPoint control2A = CGPointMake(origin2.x, origin2.y + controlOffsetDistance);
    CGPoint control2B = CGPointMake(dest2.x - controlOffsetDistance, dest2.y);
    [path addCurveToPoint:dest2 controlPoint1:control2A controlPoint2:control2B];

    // 右下弧
    CGPoint origin3 = dest2;
    CGPoint dest3 = origin0;
    CGPoint control3A = CGPointMake(origin3.x + controlOffsetDistance, origin3.y);
    CGPoint control3B = CGPointMake(dest3.x, dest3.y + controlOffsetDistance);
    [path addCurveToPoint:dest3 controlPoint1:control3A controlPoint2:control3B];

    CGContextAddPath(ctx, path.CGPath);

    CGContextSetLineWidth(ctx, kLineWidth);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blueColor].CGColor);
    CGContextStrokePath(ctx);

    // 辅助点
    UIBezierPath *pointsPath = [UIBezierPath bezierPath];
    [self addArcForPath:pointsPath atPoint:origin0];
    [self addArcForPath:pointsPath atPoint:control0A];
    [self addArcForPath:pointsPath atPoint:control0B];
    [self addArcForPath:pointsPath atPoint:dest0];

    [self addArcForPath:pointsPath atPoint:origin1];
    [self addArcForPath:pointsPath atPoint:control1A];
    [self addArcForPath:pointsPath atPoint:control1B];
    [self addArcForPath:pointsPath atPoint:dest1];

    [self addArcForPath:pointsPath atPoint:origin2];
    [self addArcForPath:pointsPath atPoint:control2A];
    [self addArcForPath:pointsPath atPoint:control2B];
    [self addArcForPath:pointsPath atPoint:dest2];

    [self addArcForPath:pointsPath atPoint:origin3];
    [self addArcForPath:pointsPath atPoint:control3A];
    [self addArcForPath:pointsPath atPoint:control3B];
    [self addArcForPath:pointsPath atPoint:dest3];

    CGContextAddPath(ctx, pointsPath.CGPath);

    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextFillPath(ctx);

    // 辅助线
    UIBezierPath *linePath = [UIBezierPath bezierPath];

    [linePath moveToPoint:origin0];
    [linePath addLineToPoint:control0A];
    [linePath addLineToPoint:control0B];
    [linePath addLineToPoint:dest0];

    [linePath addLineToPoint:origin1];
    [linePath addLineToPoint:control1A];
    [linePath addLineToPoint:control1B];
    [linePath addLineToPoint:dest1];

    [linePath addLineToPoint:origin2];
    [linePath addLineToPoint:control2A];
    [linePath addLineToPoint:control2B];
    [linePath addLineToPoint:dest2];

    [linePath addLineToPoint:origin3];
    [linePath addLineToPoint:control3A];
    [linePath addLineToPoint:control3B];
    [linePath addLineToPoint:dest3];

    CGContextAddPath(ctx, linePath.CGPath);

    CGContextSetLineWidth(ctx, 2);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokePath(ctx);
}

#pragma mark - tools
- (void)addArcForPath:(UIBezierPath *)path atPoint:(CGPoint)point {
    CGFloat pointRadius = 3;
    [path moveToPoint:point];
    [path addArcWithCenter:point radius:pointRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
}

@end
