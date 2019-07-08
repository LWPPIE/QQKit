//
//  LKProgressView.m
//  LKNovelty
//
//  Created by RoyLei on 16/12/3.
//  Copyright © 2016年 Laka. All rights reserved.
//

#import "LKProgressView.h"
#import "LSYConstance.h"
#import "YYCGUtilities.h"
#import "CAAnimation+Blocks.h"

static const CGFloat LKCenterHoleInsetRatio             = 0.3f;
static const CGFloat LKProgressShapeInsetRatio          = 0.03f;
static const CGFloat LKDefaultAlpha                     = 0.45f;
static const CFTimeInterval LKScaleAnimationDuration    = 0.5;

@interface LKProgressView ()

@property (nonatomic, strong) CAShapeLayer *boxShape;
@property (nonatomic, strong) CAShapeLayer *circleShape;
@property (nonatomic, strong) CAShapeLayer *progressShape;

@end

@implementation LKProgressView

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.alpha = LKDefaultAlpha;
        
        self.boxShape = [CAShapeLayer layer];
        self.boxShape.fillColor         = UIColorHexAndAlpha(0x000000, 0.45).CGColor;
        self.boxShape.anchorPoint       = CGPointMake(0.5f, 0.5f);
        self.boxShape.contentsGravity   = kCAGravityCenter;
        self.boxShape.fillRule          = kCAFillRuleEvenOdd;
        
        self.circleShape = [CAShapeLayer layer];
        self.circleShape.fillColor    = [UIColor clearColor].CGColor;
        self.circleShape.strokeColor  = UIColorHexAndAlpha(0xffffff, 0.80).CGColor;
        
        self.progressShape = [CAShapeLayer layer];
        self.progressShape.strokeEnd    = 0.0f;
        self.progressShape.fillColor    = [UIColor clearColor].CGColor;
        self.progressShape.strokeColor  = UIColorHexAndAlpha(0xffffff, 0.80).CGColor;
        
        [self.layer addSublayer:self.boxShape];
        [self.layer addSublayer:self.circleShape];
        [self.layer addSublayer:self.progressShape];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat minSide = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    CGFloat centerHoleInset     = LKCenterHoleInsetRatio * minSide;
    CGFloat progressShapeInset  = LKProgressShapeInsetRatio * minSide;
    
    CGRect pathRect = CGRectMake(CGPointZero.x,
                                 CGPointZero.y,
                                 CGRectGetWidth(self.bounds),
                                 CGRectGetHeight(self.bounds));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:pathRect];
    
    CGFloat width = minSide - (centerHoleInset * 2);
    CGFloat height = width;
    
    UIBezierPath *centerPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((CGRectGetWidth(self.bounds) - width) / 2.0f,
                                                                                  (CGRectGetHeight(self.bounds) - height) / 2.0f,
                                                                                  width,
                                                                                  height)
                                                          cornerRadius:(width / 2.0f)];
    
    [path appendPath:centerPath];
    [path setUsesEvenOddFillRule:YES];
    
    self.boxShape.path = path.CGPath;
    self.boxShape.bounds = pathRect;
    self.boxShape.position = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect));
    
    CGFloat diameter = minSide - (2 * centerHoleInset) - (2 * progressShapeInset);
    CGFloat radius = diameter / 2.0f;
    
    self.progressShape.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((CGRectGetWidth(self.bounds) / 2.0f) - (radius / 2.0f),
                                                                                 (CGRectGetHeight(self.bounds) / 2.0f) - (radius / 2.0f),
                                                                                 radius,
                                                                                 radius)
                                                         cornerRadius:radius].CGPath;
    self.progressShape.lineWidth = radius;

    self.circleShape.path = centerPath.CGPath;
    self.circleShape.lineWidth = 1.0;
}

- (void)setProgress:(float)progress
{
    if ([self pinnedProgress:progress] != _progress) {
        
        self.circleShape.opacity = 1.0f;
        self.progressShape.opacity = 1.0f;
        self.progressShape.strokeEnd = progress;
        
        if (_progress == 1.0f && progress < 1.0f) {
            [self.boxShape removeAllAnimations];
            [self.circleShape removeAllAnimations];
            [self.progressShape removeAllAnimations];
        }
        
        _progress = [self pinnedProgress:progress];
        
        if (_progress == 1.0f) {
            CGFloat minSide = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
            
            CGFloat centerHoleDiameter =  minSide - (LKCenterHoleInsetRatio * minSide * 2);
            CGFloat desiredDiameter = 2 * sqrt((powf((CGRectGetWidth(self.bounds) / 2.0f), 2) + powf((CGRectGetHeight(self.bounds) / 2.0f), 2)));
            CGFloat scaleFactor = desiredDiameter / centerHoleDiameter;
            
            self.boxShape.opacity = 1.0f;
            CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleAnimation.toValue = @(scaleFactor);
            scaleAnimation.duration = LKScaleAnimationDuration;
            scaleAnimation.removedOnCompletion = NO;
            scaleAnimation.autoreverses = NO;
            scaleAnimation.fillMode = kCAFillModeForwards;
            [self.boxShape addAnimation:scaleAnimation forKey:@"transform.scale"];
            
            CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            opacityAnimation.toValue = @(0.0f);
            opacityAnimation.duration = LKScaleAnimationDuration;
            opacityAnimation.removedOnCompletion = NO;
            opacityAnimation.autoreverses = NO;
            opacityAnimation.fillMode = kCAFillModeForwards;
            
            @weakify(self)
            opacityAnimation.completion = ^(BOOL finisheds){
                weak_self.progressShape.opacity = 0.0f;
                weak_self.circleShape.opacity = 0.0f;
                weak_self.boxShape.opacity = 0.0f;
            };
            
            [self.circleShape addAnimation:opacityAnimation forKey:@"opacityAnimation"];
            [self.progressShape addAnimation:opacityAnimation forKey:@"opacityAnimation"];
        }
    }
}

- (float)pinnedProgress:(float)progress
{
    float pinnedProgress = MAX(0.0f, progress);
    pinnedProgress = MIN(1.0f, pinnedProgress);
    
    return pinnedProgress;
}

@end
