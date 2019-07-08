//
//  POPBasicAnimation+Helper.h
//  AnimationTool
//
//  Created by Heller on 16/4/14.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import <POP/POP.h>

@interface CALayer (POPAnimation)
- (POPBasicAnimation *)positionAnimation:(CGPoint)toPosition beginTime:(CFTimeInterval)beginTime duration:(CGFloat)duration;
- (POPBasicAnimation *)scaleAnimation:(CGSize)toSize beginTime:(CFTimeInterval)beginTime duration:(CGFloat)duration;
- (POPBasicAnimation *)rotateAnimation:(CGFloat)toValue beginTime:(CFTimeInterval)beginTime duration:(CGFloat)duration;
- (POPBasicAnimation *)positionXAnimation:(CGFloat)toX beginTime:(CFTimeInterval)beginTime duration:(CGFloat)duration;
- (POPBasicAnimation *)positionYAnimation:(CGFloat)toY beginTime:(CFTimeInterval)beginTime duration:(CGFloat)duration repeat:(BOOL)repeat count:(int)count;

- (POPBasicAnimation *)alphaAnimation:(CGFloat)toValue beginTime:(CFTimeInterval)beginTime duration:(CGFloat)duration repeat:(BOOL)repeat;


@end
