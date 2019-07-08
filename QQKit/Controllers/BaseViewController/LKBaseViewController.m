//
//  LKBaseViewController.m
//  LKNovelty
//
//  Created by RoyLei on 16/11/9.
//  Copyright © 2016年 Laka. All rights reserved.
//

#import "LKBaseViewController.h"
#import <YYKit/NSObject+YYAddForKVO.h>
#import <YYKit/UIView+YYAdd.h>
#import <YYKit/UIImage+YYAdd.h>

#import "LKMacros.h"
#import "LKAppearance.h"

@interface LKBaseViewController ()

@end

@implementation LKBaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lv_showNavgationBar = YES;
        self.lv_navigationBarBackgroundHidden = NO;
        self.lk_statusBarStyle = UIStatusBarStyleLightContent;
        self.lk_supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setBackgroundColor:[LKAppearance sharedInstance].mainBGColor];

    WS(weakSelf)
    [self addObserverBlockForKeyPath:@"lk_statusBarHidden" block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
        if ([oldVal boolValue] != [newVal boolValue]) {
            [weakSelf setNeedsStatusBarAppearanceUpdate];
        }
    }];

    [self addObserverBlockForKeyPath:@"lk_statusBarStyle" block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
        if ([oldVal boolValue] != [newVal boolValue]) {
            [weakSelf setNeedsStatusBarAppearanceUpdate];
        }
    }];
}

- (void)dealloc
{
    [self removeObserverBlocks];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return _lk_statusBarStyle;
}

- (BOOL)prefersStatusBarHidden
{
    return _lk_statusBarHidden;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return _lk_supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
