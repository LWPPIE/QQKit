//
//  LSYPanGestureRecognizer.m
//
//  Created by RoyLei on 15/4/30.
//  Copyright (c) 2015年 RoyLei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIGestureRecognizerSubclass.h>

@interface LSYPanGestureRecognizer : UIPanGestureRecognizer
@property (readonly, nonatomic) UIEvent *event;
- (CGPoint)beganLocationInView:(UIView *)view;
@end
