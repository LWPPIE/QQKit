//
//  LKAvatarImageView.h
//  LKNovelty
//
//  Created by RoyLei on 16/12/8.
//  Copyright © 2016年 Laka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKAvatarImageView : UIImageView

@property (strong, nonatomic, readonly) UIView *bgMarkView;
@property (strong, nonatomic, readonly) UIImageView *coverImageView;

/**
 设置默认图

 @param placeholder 默认Image
 @return 返回默认图
 */
- (UIImage *)setPlaceholderImage:(UIImage *)placeholder;

/**
 裁剪了并设置圆形头像方法，同时缓存在本地

 @param imageURLStr imageUrl 字符串
 @param placeholder 默认显示图
 */
- (void)lk_setRoundAvatarImageWithURLStr:(NSString *)imageURLStr placeholder:(UIImage *)placeholder;

@end
