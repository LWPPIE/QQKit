//
//  POPBasicAnimation+Helper.m
//  AnimationTool
//
//  Created by Heller on 16/4/14.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import "CALayer+POPAnimation.h"

@implementation CALayer (POPAnimation)

- (POPBasicAnimation *)positionAnimation:(CGPoint)toPosition beginTime:(CFTimeInterval)beginTime duration:(CGFloat)duration
{
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
    animation.toValue = [NSValue valueWithCGPoint:toPosition];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = duration;
    animation.beginTime = CACurrentMediaTime() + beginTime;
    [self pop_addAnimation:animation forKey:nil];
    
    return animation;
}

- (POPBasicAnimation *)positionXAnimation:(CGFloat)toX beginTime:(CFTimeInterval)beginTime duration:(CGFloat)duration
{
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    animation.toValue = [NSNumber numberWithFloat:toX];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = duration;
    animation.beginTime = CACurrentMediaTime() + beginTime;
    [self pop_addAnimation:animation forKey:nil];
    
    return animation;
}

- (POPBasicAnimation *)positionYAnimation:(CGFloat)toY beginTime:(CFTimeInterval)beginTime duration:(CGFloat)duration repeat:(BOOL)repeat count:(int)count
{
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    animation.toValue = [NSNumber numberWithFloat:toY];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = duration;
    animation.beginTime = CACurrentMediaTime() + beginTime;
    if(repeat)
    {
        animation.autoreverses = YES;
        animation.repeatCount = count;
    }
    
    [self pop_addAnimation:animation forKey:nil];
    
    return animation;
}

- (POPBasicAnimation *)scaleAnimation:(CGSize)toSize beginTime:(CFTimeInterval)beginTime duration:(CGFloat)duration
{
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    animation.toValue = [NSValue valueWithCGSize:toSize];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.beginTime = CACurrentMediaTime() + beginTime;
    animation.duration = duration;
    [self pop_addAnimation:animation forKey:nil];
    
    return animation;
}

- (POPBasicAnimation *)rotateAnimation:(CGFloat)toValue beginTime:(CFTimeInterval)beginTime duration:(CGFloat)duration
{
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    animation.toValue = [NSNumber numberWithFloat:toValue];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.beginTime = CACurrentMediaTime() + beginTime;
    animation.duration = duration;
    [self pop_addAnimation:animation forKey:nil];
    
    return animation;
}

- (POPBasicAnimation *)alphaAnimation:(CGFloat)toValue beginTime:(CFTimeInterval)beginTime duration:(CGFloat)duration repeat:(BOOL)repeat
{
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    animation.toValue = [NSNumber numberWithFloat:toValue];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = duration;
    animation.beginTime = CACurrentMediaTime() + beginTime;
    if(repeat)
    {
        animation.autoreverses = YES;
        animation.repeatForever = YES;
    }
    [self pop_addAnimation:animation forKey:nil];
    
    return animation;
}

@end
