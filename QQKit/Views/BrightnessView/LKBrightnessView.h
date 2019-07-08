//
//  LKBrightnessView.h
//  Pods
//
//  Created by RoyLei on 16/12/7.
//
//

#import <UIKit/UIKit.h>

@interface LKBrightnessView : UIView

/** 调用单例记录播放状态是否锁定屏幕方向*/
@property (nonatomic, assign) BOOL     isLockScreen;
/** 是否允许横屏,来控制只有竖屏的状态*/
@property (nonatomic, assign) BOOL     isAllowLandscape;

@property (weak, nonatomic) UIView  *landscapeContainerView;

- (void)showBrightnessView;

@end
