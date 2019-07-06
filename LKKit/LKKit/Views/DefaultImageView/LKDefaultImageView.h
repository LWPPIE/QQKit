//
//  LKDefaultImageView.h
//  LKNovelty
//
//  Created by RoyLei on 16/12/16.
//  Copyright © 2016年 Laka. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 ContentModeCenter模式 显示默认图：default_icon_30，可以自己设置image
 */
@interface LKDefaultImageView : UIImageView

@property (strong, nonatomic, readonly) UIImageView *topImageView;
@property (strong, nonatomic, readonly) UIImageView *coverImageView;

/**
 增加过度效果显示图片
 
 @param imageURLStr image Url String
 */
- (void)setImageFadeWithURLStr:(NSString *)imageURLStr;

/**
 增加过度效果显示高斯模糊效果图片
 
 @param imageURLStr image Url String
 */
- (void)setImageFadeAndBlurWithURLStr:(NSString *)imageURLStr;

/**
 生成渐变层初始化方法
 */
- (instancetype)initWithGradientFrame:(CGRect)frame;

@end
