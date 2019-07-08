//
//  LSYConstance.h
//  TTClub
//
//  Created by RoyLei on 15/12/2.
//  Copyright © 2015年 TTClub. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
* Step 1:
* Import the header in your implementation or prefix file:
*
* #import <LKKit/LKKit.h>
*
* Step 2:
* Setup static UIColor *LKMainColor(){return [UIColor whiteColor]};
* Setup static UIColor *LKMainBGColor(){return [UIColor whiteColor]};
*
* #import <LKKit/LKKit.h>
*/

FOUNDATION_EXPORT NSInteger const LKDefaultStartPage; /**< 默认第一页页号 */
FOUNDATION_EXPORT NSInteger const LKDefaultReqCount;  /**< 默认一页请求数 */

UIKIT_EXTERN NSInteger const LSYKeyBoardBarViewHeight;
UIKIT_EXTERN NSInteger const LSYNavBarHeight;
UIKIT_EXTERN NSInteger const LSYStatusHeight;

#pragma mark - Inline Method

static inline BOOL TTObjectIsNil(id obj) {
    return (obj ? NO : YES);
};

/**
 本地化显示字符串
 
 @param str 要本地化显示的字符串
 */
static inline NSString *LKLocalizedString(NSString *str){
    return NSLocalizedString(str, nil);
}

#pragma mark - NSString

static inline BOOL NSStringIsEmpty(NSString *str) {
    return (str == nil || [@"" isEqualToString:str]);
}

static inline NSString * TTStringNotNil(NSString *string) {
    return (string ? string : @"");
};

static inline NSString * TTStringNilToZero(NSString *string) {
    if (!string) {
        string = @"0";
        return string;
    }
    return string;
};

#pragma mark - UIFont

static inline UIFont * LKFont(CGFloat fontSize) {
    return [UIFont systemFontOfSize:fontSize];
}

static inline UIFont * LKBoldFont(CGFloat fontSize) {
    return [UIFont boldSystemFontOfSize:fontSize];
}

#pragma mark - Image

static inline UIImage *LKImage(NSString *imageName) {
    return [UIImage imageNamed:imageName];
}

#pragma mark - View Position

static inline CGFloat LKViewBottomY(UIView *view) {
    return CGRectGetMaxY(view.frame);
}

static inline CGFloat LKViewRightX(UIView *view) {
    return CGRectGetMaxX(view.frame);
}

static inline void LKViewSetFrame(UIView *view, CGFloat x, CGFloat y, CGFloat w, CGFloat h) {
    view.frame = CGRectMake(x, y, w, h);
}

static inline CGFloat LKCGRectGetMaxY(UIView *view) {
    return CGRectGetMaxY(view.frame);
}

static inline CGFloat LKCGRectGetMaxX(UIView *view) {
    return CGRectGetMaxX(view.frame);
};

static inline CGFloat LKVerticalScreenWidth(){
    return MIN([UIScreen mainScreen].bounds.size.width,
               [UIScreen mainScreen].bounds.size.height);
}

static inline CGFloat LKVerticalScreenHeight(){
    return MAX([UIScreen mainScreen].bounds.size.width,
               [UIScreen mainScreen].bounds.size.height);
}

static inline CGFloat LKTabBarHeight() {
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    if(rectStatus.size.height == 44) {
        return 83;
    }else {
        return 49;
    }
}

static inline CGFloat LKNavigationBarHeight() {
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    if(rectStatus.size.height == 44) {
        return 88;
    }else {
        return 64;
    }
}

static inline CGFloat LKSafeAreaBottomHeight() {
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    if(rectStatus.size.height == 44) {
        return 34;
    }else {
        return 0;
    }
}


#pragma mark - 快捷适配函数

static inline NSString *LKAppShortVersion() {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersionStr = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return appVersionStr;
}

static inline NSString *LKAppBundleVersion() {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersionStr = [infoDictionary objectForKey:@"CFBundleVersion"];
    return appVersionStr;
}

/**
 *  适配5、6、6P~尺寸
 *  @param plist 参数列表，尺寸依次是多少例如(@[@10,@20,@30])
 *  @return 对应浮点数，例如(@[@10,@20,@30])5返回10，6返回20，6P返回30; (@[@10,@20) 5返回10，6和6P返回20; (@[@10])5、6、6P都返回10。
 */
FOUNDATION_EXPORT CGFloat g_fitFloat(NSArray *plist);

/**
 *  适配4/4s、5、6、6P~尺寸
 *  @param plist 参数列表，尺寸依次是多少例如(@[@7,@10,@20,@30])
 *  @return 对应浮点数，例如(@[@7,@10,@20,@30])4/4s返回的是7 5返回10，6返回20，6P返回30; (@[@10,@20) 4s/5返回10，6和6P返回20; (@[@10])4、5、6、6P都返回10。
 */
FOUNDATION_EXPORT CGFloat g_fitFloatWith4s(NSArray * plist);
/**
 *  适配5、6、6P~尺寸
 *  @param plist 参数列表，字体大小依次是多少例如(@[@10,@20,@30])、(@[@10,@20)、(@[@10])
 *  @return 返回对应字体大小,(@[@10,@20,@30])5返回10号字体，6返回20号字体，6P返回30号字体; (@[@10,@20) 5返回10号字体，6和6P返回20号字体; (@[@10])5、6、6P都返回10号字体。
 */
FOUNDATION_EXPORT UIFont *g_fitSystemFontSize(NSArray *plist);

FOUNDATION_EXPORT CGFloat g_fitScareOfIphone6(CGFloat f);

/**
 *  适配5、6、6P~尺寸
 *  @param plist 参数列表，尺寸依次是多少例如(@[@10,@20,@30])
 *  @return 对应浮点数，例如(@[@10,@20,@30])5返回10，6返回20，6P返回30; (@[@10,@20) 5返回10，6和6P返回20; (@[@10])5、6、6P都返回10。
 */
FOUNDATION_EXPORT CGFloat g_fitFloat(NSArray *plist);

FOUNDATION_EXPORT UIColor *UIColorHexAndAlpha(long hexColor, float opacity);

FOUNDATION_EXPORT UIColor *UIColorWithHex(long hexColor);

/**
 *  生成对应的MD5 字符串
 *
 *  @param key 要计算MD5的字符串
 *
 *  @return 返回生成后的MD5
 */
FOUNDATION_EXPORT inline NSString *makeMD5StringForKey(NSString *key);

#ifdef TTClubNeedStatisticesLog
FOUNDATION_EXPORT void TTClubStatisticesLog(NSString *format, ...);

FOUNDATION_EXPORT void TTClubLog(TTClubLogLevel level, NSString *format, ...);
#endif

FOUNDATION_EXPORT NSString *LKDeviceModelName();

FOUNDATION_EXPORT BOOL LKIsiPhone6sAbove();


