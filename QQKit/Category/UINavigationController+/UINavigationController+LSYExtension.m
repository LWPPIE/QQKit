//
//  UINavigationController+LSYExtension.m
//  TTClub
//
//  Created by RoyLei on 15/12/18.
//  Copyright © 2015年 TTClub. All rights reserved.
//

#import "UINavigationController+LSYExtension.h"
#import "UINavigationBar+LSYExtension.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSNumber (LSYExtension)
- (CGFloat)CGFloatValue {
#if CGFLOAT_IS_DOUBLE
    return [self doubleValue];
#else
    return [self floatValue];
#endif
}
@end

@implementation UINavigationController(LSYExtension)

- (CGFloat)lv_navigationBarBackgroundAlpha {
    return [[self.navigationBar lv_backgroundView] alpha];
}

- (UIViewController *)lv_interactivePopedViewController {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLv_navigationBarBackgroundAlpha:(CGFloat)navigationBarBackgroundAlpha {
    [[self.navigationBar lv_backgroundView] setAlpha:navigationBarBackgroundAlpha];
    // navigationBarBackgroundAlpha == 0 means hidden so do not set.
    if (!navigationBarBackgroundAlpha) return;
    self.lv_navigationBarBackgroundReverseAlpha = 1-navigationBarBackgroundAlpha;
}

- (void)setLv_interactivePopedViewController:(UIViewController *)interactivePopedViewController {
    objc_setAssociatedObject(self, @selector(lv_interactivePopedViewController), interactivePopedViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setLv_navigationBarBackgroundReverseAlpha:(CGFloat)_navigationBarBackgroundReverseAlpha {
    objc_setAssociatedObject(self, @selector(lv_navigationBarBackgroundReverseAlpha), @(_navigationBarBackgroundReverseAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)lv_navigationBarBackgroundReverseAlpha {
    return [objc_getAssociatedObject(self, _cmd) CGFloatValue];
}

- (void)lk_popTopViewControllerAndThenToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSMutableArray *viewControllers = self.viewControllers.mutableCopy;
    [viewControllers insertObject:viewController atIndex:1];
    self.viewControllers = [NSArray arrayWithArray:viewControllers];
    
    [self popToViewController:viewController animated:animated];
}

@end
