//
//  UINavigationController+LSYExtension.h
//  TTClub
//
//  Created by RoyLei on 15/12/18.
//  Copyright © 2015年 TTClub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController(LSYExtension)

@property (nonatomic, assign) CGFloat lv_navigationBarBackgroundAlpha NS_AVAILABLE_IOS(7_0); // navigationBar's background alpha, when 0 your

@property (nonatomic, strong) __kindof UIViewController *lv_interactivePopedViewController NS_AVAILABLE_IOS(7_0); // The view controller that is being popped
@property (nonatomic, assign) CGFloat lv_navigationBarBackgroundReverseAlpha;

/**
 弹出顶部viewController，再push新的viewController
 
 @param viewController push新的viewController
 @param animated 动画
 */
- (void)lk_popTopViewControllerAndThenToViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
