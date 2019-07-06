//
//  LKMacros.h
//  LKKit
//
//  Created by RoyLei on 16/7/21.
//  Copyright © 2016年 RoyLei. All rights reserved.
//

#ifndef LKMacros_h
#define LKMacros_h

#define WS(weakSelf) __weak __typeof(&*self) weakSelf = self;

// 设备相关
//宏定义宽高  方便不同设备的适配
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth  [UIScreen mainScreen].bounds.size.width
//宏定义屏幕大小的比例
#define kDeviceRatio    (kDeviceWidth / 375.0)
#define kDeviceScale    [UIScreen mainScreen].scale
#define UI_SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define UI_SCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height
#define SCREEN_MAX_LENGTH (MAX(UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT))

#define is_Pad            ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define IS_IPHONE        (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4      (IS_IPHONE && SCREEN_MAX_LENGTH == 480.0)
#define IS_IPHONE_5      (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6      (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P     (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_4and5  (IS_IPHONE && UI_SCREEN_WIDTH   == 320.0)
#define IS_IPHONE_X      (IS_IPHONE && SCREEN_MAX_LENGTH >= 812.0)

#define IS_IPHONE_Xr     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !is_Pad : NO)
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !is_Pad : NO)
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !is_Pad : NO)

#define IS_IPHONE_X_LIST  ([[UIApplication sharedApplication] statusBarFrame].size.height ==44)


#pragma mark - 判断系统版本控制

#define IOS7_OR_LATER   ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
#define IOS7            ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7)
#define ISIOS7          ([[[UIDevice currentDevice] systemVersion] integerValue] == 7)
#define IOS8            ([[[UIDevice currentDevice] systemVersion] integerValue] >= 8)
#define IOS9            ([[[UIDevice currentDevice] systemVersion] integerValue] >= 9)
#define IOS10           ([[[UIDevice currentDevice] systemVersion] integerValue] >= 10)

#define lk_dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define lk_dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

typedef NS_ENUM(NSInteger, LKErrorCode) {
    LK_E_NOT_CONNECT      = -2000, /**< 没有连接 */
    LK_E_CONNECT_TIME_OUT = -2001, /**< 连接超时 */
    LK_E_REQ_TIME_OUT     = -2002, /**< 请求超时 */
    LK_E_NONE             = 0,     /**< 没有错误 */
};

#endif /* LKMacros_h */
