//
//  LKBaseViewController.h
//  LKNovelty
//
//  Created by RoyLei on 16/11/9.
//  Copyright © 2016年 Laka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+LSYExtension.h"

@interface LKBaseViewController : UIViewController

@property (assign, nonatomic) UIStatusBarStyle lk_statusBarStyle; /**< 设置状态栏样式 */
@property (assign, nonatomic) UIInterfaceOrientationMask lk_supportedInterfaceOrientations; /**< 播放器全屏播放用到 */
@property (assign, nonatomic) BOOL lk_shouldAutorotate; /**< 是否支持自动旋屏 */
@property (assign, nonatomic) BOOL lk_statusBarHidden;  /**< 是否显示状态栏 */

@end
