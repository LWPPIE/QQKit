//
//  LSYShowAnimation.m
//  13Helper
//
//  Created by TTClub RoyLei on 14/11/25.
//  Copyright (c) 2014年 TTClub. All rights reserved.
//

#import "LSYShowAnimation.h"
#import "CAAnimation+Blocks.h"
#import "RBBSpringAnimation.h"
#import "RBBTweenAnimation.h"

@implementation LSYShowAnimation

#pragma mark - Show View With Spring Gradual Animation
+ (void)showViewWithAnimation:(UIView *)view
               backgroundView:(UIView *)bgView
                   completion:(void (^)(BOOL))completion
{
    
    [CATransaction begin]; {
        CATransform3D transformFrom                 = CATransform3DScale(view.layer.transform, 1.26, 1.26, 1.0);
        CATransform3D transformTo                   = CATransform3DScale(view.layer.transform, 1.0, 1.0, 1.0);
        
        RBBSpringAnimation *modalTransformAnimation = [LSYShowAnimation springAnimationForKeyPath:@"transform"];
        modalTransformAnimation.fromValue           = [NSValue valueWithCATransform3D:transformFrom];
        modalTransformAnimation.toValue             = [NSValue valueWithCATransform3D:transformTo];
        modalTransformAnimation.completion          = completion;
        modalTransformAnimation.removedOnCompletion = YES;
        
        view.layer.transform = transformTo;
        [view.layer addAnimation:modalTransformAnimation forKey:@"transform"];
        
        [self transitView:view fromOpacity:0.0f toOpacity:1.0f];
        [self transitView:bgView fromOpacity:0.0f toOpacity:1.0f];
        
    } [CATransaction commit];
}

+ (void)hideViewWithAnimation:(UIView *)view
               backgroundView:(UIView *)bgView
                   completion:(void (^)(BOOL))completion
{
    [CATransaction begin]; {
        CATransform3D transformFrom = CATransform3DMakeScale(1.0, 1.0, 1.0);
        CATransform3D transformTo   = CATransform3DMakeScale(0.840, 0.840, 1.0);
        
        RBBSpringAnimation *modalTransformAnimation = [LSYShowAnimation springAnimationForKeyPath:@"transform"];
        modalTransformAnimation.fromValue           = [NSValue valueWithCATransform3D:transformFrom];
        modalTransformAnimation.toValue             = [NSValue valueWithCATransform3D:transformTo];
        modalTransformAnimation.removedOnCompletion = YES;
        modalTransformAnimation.duration            = 0.3;

        [modalTransformAnimation setCompletion:^(BOOL finished) {
            [view.layer setTransform:CATransform3DIdentity];
            if (completion) {
                completion(finished);
            }
        }];
        
        [view.layer addAnimation:modalTransformAnimation forKey:@"transform"];
        view.layer.transform                 = transformTo;
        
        [self transitView:view fromOpacity:1.0f toOpacity:0.0f];
        [self transitView:bgView fromOpacity:1.0f toOpacity:0.0f];
        
    } [CATransaction commit];
}

#pragma mark -
#pragma mark Popup View

+ (void)popupView:(UIView *)view
   backgroundView:(UIView *)bgView
     fromPosition:(NSInteger)fromValue
       toPosition:(NSInteger)toValue
         isBounce:(BOOL)isBounce
       completion:(void (^)(BOOL))completion
{
    [CATransaction begin]; {
    
        if (isBounce) {
            
            RBBTweenAnimation *bounce = [RBBTweenAnimation animationWithKeyPath:@"position.y"];
            bounce.fromValue = @(fromValue);
            bounce.toValue = @(toValue);
            bounce.easing = RBBEasingFunctionEaseOutBounce;
            bounce.duration = 0.30;
            bounce.fillMode = kCAFillModeForwards;
            bounce.removedOnCompletion = NO;
            [bounce setCompletion:completion];
            [view.layer addAnimation:bounce forKey:@"PositionOfY"];
            
        }else{
            
            RBBSpringAnimation *spring = [RBBSpringAnimation animationWithKeyPath:@"position.y"];
            spring.fromValue = @(fromValue);
            spring.toValue = @(toValue);
            spring.velocity = 0;
            spring.mass = 1;
            spring.damping = 100;
            spring.stiffness = 1000;
            spring.fillMode = kCAFillModeForwards;
            spring.removedOnCompletion = NO;
            [spring setCompletion:completion];

            spring.duration = 0.30;
            [view.layer addAnimation:spring forKey:@"PositionOfY"];
        }
        
        [self transitView:bgView fromOpacity:0.0f toOpacity:1.0f];
        
    } [CATransaction commit];
}

+ (void)disapearPopupView:(UIView *)view
           backgroundView:(UIView *)bgView
             fromPosition:(NSInteger)fromValue
               toPosition:(NSInteger)toValue
               completion:(void (^)(BOOL))completion
{
    [CATransaction begin]; {
        
        RBBSpringAnimation *spring = [RBBSpringAnimation animationWithKeyPath:@"position.y"];
        spring.fromValue = @(fromValue);
        spring.toValue = @(toValue);
        spring.velocity = 1;
        spring.mass = 1;
        spring.damping = 100;
        spring.stiffness = 1000;
        spring.fillMode = kCAFillModeForwards;
        spring.removedOnCompletion = NO;
        
        spring.duration = 0.25;
        
        [view setUserInteractionEnabled:NO];
        [bgView setUserInteractionEnabled:NO];
        
        [spring setCompletion:completion];
        
        [view.layer addAnimation:spring forKey:@"position"];
        
        [UIView animateWithDuration:0.1f
                              delay:0.2f
                            options:(UIViewAnimationOptionCurveEaseInOut)
                         animations:^{
                             
                             [bgView setAlpha:0.0f];
                         }
                         completion:nil];
        
    } [CATransaction commit];
}

+ (void)springAnimationWithView:(UIView *)view
           withVelocity:(CGFloat)velocity
            withDamping:(CGFloat)damping
           fromPosition:(NSInteger)fromValue
             toPosition:(NSInteger)toValue
             completion:(void (^)(BOOL))completion
{
    [CATransaction begin]; {
        RBBSpringAnimation *spring = [RBBSpringAnimation animationWithKeyPath:@"position.y"];
        spring.fromValue = @(fromValue);
        spring.toValue = @(toValue);
        spring.velocity = velocity;
        spring.damping = damping;
        spring.fillMode = kCAFillModeBoth;
        spring.removedOnCompletion = NO;
        [spring setCompletion:completion];
    
        spring.duration = 0.3;//[spring durationForEpsilon:0.01];
    
        [view.layer addAnimation:spring forKey:@"PositionOfY"];
    } [CATransaction commit];
}

#pragma mark -
#pragma mark Spring Animation

+ (void)transitView:(UIView *)view
        fromOpacity:(CGFloat)fromValue
          toOpacity:(CGFloat)toValue
{
    RBBSpringAnimation *opacityAnimation = [self springAnimationForKeyPath:@"opacity"];
    opacityAnimation.fromValue           = @(fromValue);
    opacityAnimation.toValue             = @(toValue);
    
    [view.layer addAnimation:opacityAnimation forKey:@"opacity"];
    view.layer.opacity = toValue;
}

+ (RBBSpringAnimation *)springAnimationForKeyPath:(NSString *)keyPath
{
    RBBSpringAnimation *animation = [[RBBSpringAnimation alloc] init];
    
    // Values reversed engineered from iOS 7 UIAlertView
    animation.keyPath = keyPath;
    animation.velocity = 0.0;
    animation.mass = 3.0;
    animation.stiffness = 1000.0;
    animation.damping = 500.0;
    // todo - figure out how iOS is deriving this number
    animation.duration = 0.5058237314224243;
    
    return animation;
}

@end
