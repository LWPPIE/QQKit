//
//  UILabel+CountDown.m
//  Live
//
//  Created by Heller on 16/5/25.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import "UILabel+CountDown.h"


@implementation UILabel (CountDown)

- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title completion:(void (^)())completion
{
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束，关闭
        if (timeOut <= 0)
        {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.text = title;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    if (completion) {
                        completion();
                    }
                    
                    [UIView animateWithDuration:0.25 animations:^{
                        [self setAlpha:0.0f];
                    } completion:^(BOOL finished) {
                    }];

                });
            });
        }
        else
        {
            int allTime = (int)timeLine + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.text = timeStr;
                [self numAnimation];
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

- (void)numAnimation
{
    CFTimeInterval duration = 1;
    
    // Scale animation
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    scaleAnimation.keyTimes = @[@0, @0.5, @1];
    scaleAnimation.values = @[@1, @1.5, @2];
    scaleAnimation.duration = duration;
    
    // Opacity animation
    CAKeyframeAnimation *opacityAnimaton = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimaton.keyTimes = @[@0, @0.5, @1];
    opacityAnimaton.values = @[@1, @0.5, @0];
    opacityAnimaton.duration = duration;
    
    // Animation
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    
    animation.animations = @[scaleAnimation, opacityAnimaton];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = duration;
    animation.repeatCount = 1;//HUGE;
    animation.removedOnCompletion = YES;
    animation.beginTime = CACurrentMediaTime();
    
    [self.layer addAnimation:animation forKey:@"animation"];
}

@end
