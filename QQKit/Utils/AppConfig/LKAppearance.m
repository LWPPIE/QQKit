//
//  LKAppearance.m
//  LKKit
//
//  Created by RoyLei on 16/12/17.
//  Copyright © 2016年 RoyLei. All rights reserved.
//

#import "LKAppearance.h"

@implementation LKAppearance

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mainColor = [UIColor whiteColor];
        _mainBGColor = [UIColor whiteColor];
    }
    return self;
}

@end
