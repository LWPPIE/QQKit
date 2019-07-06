//
//  UIView+Block.m
//  cinderella
//
//  Created by Heller on 15/7/10.
//  Copyright (c) 2015年 Laka inc. All rights reserved.
//

#import "UIView+Block.h"
#import <objc/runtime.h>

static char UIViewBlockKey;

@implementation UIView (Block)

- (void)handleControlEvent:(UIControlEvents)event withBlock:(ViewTouchUpInsideBlock)block
{
    objc_setAssociatedObject(self, &UIViewBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC | OBJC_ASSOCIATION_ASSIGN);
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callActionBlock:)];
    singleTap.numberOfTouchesRequired = 1;
    singleTap.numberOfTapsRequired = 1;

    [self addGestureRecognizer:singleTap];
}

- (void)callActionBlock:(UITapGestureRecognizer *)recognizer
{
    ViewTouchUpInsideBlock block = (ViewTouchUpInsideBlock)objc_getAssociatedObject(self, &UIViewBlockKey);
    if (block) {
        block(recognizer, (UIButton *)recognizer.view);
    }
}

- (void)addClickBlock:(ViewTouchUpInsideBlock)block
{
    [self handleControlEvent:UIControlEventTouchUpInside withBlock:block];
}

- (void)setUserData:(id)userData
{
    objc_setAssociatedObject(self, @"user_data", userData, OBJC_ASSOCIATION_RETAIN_NONATOMIC | OBJC_ASSOCIATION_ASSIGN);
}

- (id)getUserData
{
    return objc_getAssociatedObject(self, @"user_data");
}

@end
