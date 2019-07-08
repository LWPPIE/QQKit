//
//  LKNavigationController.m
//  LKNovelty
//
//  Created by RoyLei on 16/11/9.
//  Copyright © 2016年 Laka. All rights reserved.
//

#import "LKNavigationController.h"
#import "LSYPanGestureRecognizer.h"
#import "LSYNavigationBar.h"
#import "UIViewController+LSYExtension.h"
#import "UINavigationBar+Custom.h"

#import "LKMacros.h"
#import "LSYConstance.h"
#import <YYKit/UIView+YYAdd.h>
#import <YYKit/UIColor+YYAdd.h>

#define USE_FULLSCREENPOP_GUESTURE 1

@interface LKNavigationController()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (assign, nonatomic) BOOL viewTransitionInProgress;
@property (strong, nonatomic) LSYPanGestureRecognizer *fullscreenPopGestureRecognizer;

@end

@implementation LKNavigationController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.topViewController.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden
{
    return self.topViewController.prefersStatusBarHidden;
}

- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.needFullScreenPopGesture = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.delegate = self;
    
    [[UITextField appearance] setTintColor:UIColorWithHex(0x0426bf2)];
    
    [[UINavigationBar appearance] setTranslucent:YES];
    // 标题样式
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorHex(0x000000), NSFontAttributeName : LKFont(18)}];
    
    // 返回按钮样式
    UIImage *backImage = [UIImage imageNamed:@"title_icon_back"];
    UIImage *backImageH = [UIImage imageNamed:@"title_icon_back_h"];
    
    [[UINavigationBar appearance] setBackIndicatorImage:backImage];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backImageH];
    [[UINavigationBar appearance] setTintColor:UIColorHex(0x333333)];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorHex(0x2e2e2e),
                                                           NSFontAttributeName : LKFont(18)}];
    
    // 标题栏左右按钮样式
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorHex(0x333333),
                                                           NSFontAttributeName : LKFont(15)}
                                                forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorHex(0x333333),
                                                           NSFontAttributeName : LKFont(15)}
                                                forState:UIControlStateHighlighted];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationBar lv_bottomLineColor:UIColorWithHex(0xc8c8c8)];//改变navbar底部线条颜色
}

// 用于修正iOS8之后的系统,如果前一个界面是隐藏导航栏,使用手势来回滑动返回和进入界面造成导航栏会莫名消失的bug
- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

#if USE_FULLSCREENPOP_GUESTURE

- (LSYPanGestureRecognizer *)fullscreenPopGestureRecognizer
{
    if (!_fullscreenPopGestureRecognizer) {
        _fullscreenPopGestureRecognizer = [[LSYPanGestureRecognizer alloc] init];
        _fullscreenPopGestureRecognizer.maximumNumberOfTouches = 1;
     }
    return _fullscreenPopGestureRecognizer;
}
#pragma mark - Push

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (animated == YES )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if (self.viewTransitionInProgress) {
        return;
    }
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    if (viewController.lv_showNavgationBar && ![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.fullscreenPopGestureRecognizer]) {
        
        // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.fullscreenPopGestureRecognizer];
        
        // Forward the gesture events to the private handler of the onboard gesture recognizer.
        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        self.fullscreenPopGestureRecognizer.delegate = self;
        [self.fullscreenPopGestureRecognizer addTarget:internalTarget action:internalAction];
        
        // Disable the onboard gesture recognizer.
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    // Forward to primary implementation.
    [super pushViewController:viewController animated:animated];
    
    if (animated) {
        self.viewTransitionInProgress = YES;
    }
}
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    self.interactivePopGestureRecognizer.enabled = NO;
    
    return  [super popToRootViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.interactivePopGestureRecognizer.enabled = NO;
    
    return [super popToViewController:viewController animated:animated];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    id<UIViewControllerTransitionCoordinator> tc = navigationController.topViewController.transitionCoordinator;
    
    WS(weakSelf)
    if (IOS10) {
        [tc notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            weakSelf.viewTransitionInProgress = NO;
        }];
    }else {
        [tc notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            weakSelf.viewTransitionInProgress = NO;
        }];
    }
    
    if ([self.lvDelegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
        [self.lvDelegate navigationController:navigationController willShowViewController:viewController animated:animated];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.viewTransitionInProgress = NO;
    self.interactivePopGestureRecognizer.enabled = YES;
    
    if ([self.lvDelegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        [self.lvDelegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
}

- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController
{
    if ([self.lvDelegate respondsToSelector:@selector(navigationControllerSupportedInterfaceOrientations:)]) {
        return [self.lvDelegate navigationControllerSupportedInterfaceOrientations:navigationController];
    }else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController
{
    if ([self.lvDelegate respondsToSelector:@selector(navigationControllerPreferredInterfaceOrientationForPresentation:)]) {
        return [self.lvDelegate navigationControllerPreferredInterfaceOrientationForPresentation:navigationController];
    }else {
        return UIInterfaceOrientationPortrait;
    }
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    if ([self.lvDelegate respondsToSelector:@selector(navigationController:interactionControllerForAnimationController:)]) {
        return [self.lvDelegate navigationController:navigationController interactionControllerForAnimationController:animationController];
    }else {
        return nil;
    }
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC
{
    if ([self.lvDelegate respondsToSelector:@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)]) {
        return [self.lvDelegate navigationController:navigationController animationControllerForOperation:operation fromViewController:fromVC toViewController:toVC];
    }else {
        return nil;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // Ignore when no view controller is pushed into the navigation stack.
    
    UIViewController *topViewController = self.viewControllers.lastObject;
    
    if (!topViewController.lv_showNavgationBar || self.viewControllers.count <= 1) {
        return NO;
    }
    
    // Ignore pan gesture when the navigation controller is currently in transition.
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    // Prevent calling the handler when the gesture begins in an opposite direction.
//    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
//    if (translation.x <= 0) {
//        return NO;
//    }
    
    return YES;
}

- (void)cancelOtherGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    NSSet *touchs = [self.fullscreenPopGestureRecognizer.event touchesForGestureRecognizer:otherGestureRecognizer];
    [otherGestureRecognizer touchesCancelled:touchs withEvent:self.fullscreenPopGestureRecognizer.event];
}

//与UIScrollView 手势事件冲突处理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (!self.fullscreenPopGestureRecognizer ||
        gestureRecognizer != self.fullscreenPopGestureRecognizer) return NO;
    if (self.fullscreenPopGestureRecognizer.state != UIGestureRecognizerStateBegan) return NO;
    
    UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint touchPoint = [self.fullscreenPopGestureRecognizer beganLocationInView:self.view];
    
    CGPoint velocity = [panGesture velocityInView:self.view];

    float x = velocity.x;
    float y = velocity.y;
    
    double angle = atan2(y, x) * 180.0f / M_PI;
    
    if (angle < -30 || angle > 30) { // 判断滑动角度
        [self cancelOtherGestureRecognizer:panGesture];
        return NO;
    }
    
    if ([[otherGestureRecognizer view] isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)[otherGestureRecognizer view];

        if (!self.needFullScreenPopGesture) {
            if (touchPoint.x < 20) {
                [self cancelOtherGestureRecognizer:scrollView.panGestureRecognizer];
                return YES;
            }
        }else {
            if (scrollView.contentOffset.x <= 0.01 ||
                touchPoint.x < 20) {
                [self cancelOtherGestureRecognizer:scrollView.panGestureRecognizer];
                return YES;
            }else {
                return NO;
            }
        }
    }
    
    if (NO == self.needFullScreenPopGesture) {
        if (touchPoint.x < 20) {
            return YES;
        }else {
            return NO;
        }
    }
    
    return YES;
}
#endif

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UISlider class]]) {
        // prevent recognizing touches on the slider
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return YES;
    }else {
        return NO;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

@end
