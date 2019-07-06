//
//  LKExpandHitButton.m
//  LKKit
//
//  Created by RoyLei on 2017/4/12.
//  Copyright © 2017年 RoyLei. All rights reserved.
//

#import "LKExpandHitButton.h"

@implementation LKExpandHitButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    UIEdgeInsets insets = self.expandHitEdgeInsets;
    if (UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero)) {
        return [self pointInside:point withEvent:event];
    } else {
        CGRect hitBounds = UIEdgeInsetsInsetRect(self.bounds, insets);
        return CGRectContainsPoint(hitBounds, point);
    }
}

@end
