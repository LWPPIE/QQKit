//
//  UIButton+Block.m
//  cinderella
//
//  Created by Heller on 15/7/10.
//  Copyright (c) 2015年 Laka inc. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>

static char UIButtonBlockKey;

@implementation UIButton (Block)

- (void)handleControlEvent:(UIControlEvents)event withBlock:(TouchUpInsideBlock)block
{
    objc_setAssociatedObject(self, &UIButtonBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC | OBJC_ASSOCIATION_ASSIGN);
//    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callActionBlock:)];
    singleTap.numberOfTouchesRequired = 1;
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];
}

- (void)callActionBlock:(UIGestureRecognizer *)recognizer
{
    TouchUpInsideBlock block = (TouchUpInsideBlock)objc_getAssociatedObject(self, &UIButtonBlockKey);
    if (block)
        block((UIButton *)recognizer.view);
}

//- (void)callActionBlock:(UIButton *)sender
//{
//    TouchUpInsideBlock block = (TouchUpInsideBlock)objc_getAssociatedObject(self, &UIButtonBlockKey);
//    if (block)
//        block(sender);
//}

- (void)addClickBlock:(TouchUpInsideBlock)block
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


- (void)setUserIndex:(id)index
{
    objc_setAssociatedObject(self, @"index", index, OBJC_ASSOCIATION_RETAIN_NONATOMIC | OBJC_ASSOCIATION_ASSIGN);
}

- (id)getUserIndex
{
    return objc_getAssociatedObject(self, @"index");
}

- (void)setUserData:(id)userData key:(NSString *)key
{
    objc_setAssociatedObject(self, [key UTF8String], userData, OBJC_ASSOCIATION_RETAIN_NONATOMIC | OBJC_ASSOCIATION_ASSIGN);
}

- (id)getUserData:(NSString *)key
{
    return objc_getAssociatedObject(self, [key UTF8String]);
}

@end
