//
//  UIImageView+LKWebImage.h
//  Pods
//
//  Created by RoyLei on 16/11/15.
//
//

#import <UIKit/UIKit.h>
#import "UIImageView+YYWebImage.h"

typedef void (^LKWebImageCompletionBlock)(UIImage * _Nullable image,
UIImage * _Nullable effectImage,
NSURL *url,
YYWebImageFromType from,
YYWebImageStage stage,
NSError * _Nullable error);

@interface UIImageView(LKWebImage)

/**
 增加过度效果显示图片
 
 @param imageURLStr image Url String
 */
- (void)lk_setImageFadeWithURLStr:(NSString *)imageURLStr;

/**
 增加过度效果显示图片
 
 @param imageURLStr image Url String
 @param placeholder 默认图
 */
- (void)lk_setImageFadeWithURLStr:(NSString *)imageURLStr placeholder:(UIImage *)placeholder;

/**
 增加过度效果显示高斯模糊图片
 
 @param imageURLStr image Url String
 */
- (void)lk_setImageFadeAndBlurWithURLStr:(NSString *)imageURLStr;

/**
 增加过度效果显示高斯模糊图片
 
 @param imageURLStr image Url String
 @param placeholder 默认图
 */
- (void)lk_setImageFadeAndBlurWithURLStr:(NSString *)imageURLStr placeholder:(UIImage *)placeholder;

/**
 设置模糊化图片，动画隐藏coverImageView

 @param imageURLStr image Url String
 @param blurImageView    覆模糊化ImageView
 @param placeholder      placeholder
 */
- (void)lk_setImageFadeAndBlurWithURLStr:(NSString *)imageURLStr
                           blurImageView:(UIImageView *)blurImageView
                             placeholder:(UIImage *)placeholder;

/**
 增加过度效果显示高斯模糊图片
 
 @param imageURLStr  image Url String
 @param compressSize 模糊前压缩尺寸
 @param placeholder  默认图
 */
- (void)lk_setImageFadeAndBlurWithURLStr:(NSString *)imageURLStr compressSize:(CGSize)compressSize placeholder:(UIImage *)placeholder;

/**
 获取网络图片后，做模糊处理再显示图片
 
 @param imageURLStr 图片地址Url
 @param compressSize 模糊前压缩尺寸
 @param choiceToBlur 选择性生成模糊化图片，如果返回的图片长宽比和当前ImageView的一致则不显示模糊化背景, 
                     此处主要用于精彩视频模糊背景选择性显示
 @param placeholder 默认图片
 @param blurRadius 模糊半径
 @param color 模糊颜色
 @param saturationDeltaFactor 饱和度
 */
- (void)lk_setBlurImageWithURLStr:(NSString *)imageURLStr
                    fadeAnimation:(BOOL)fadeAnimation
                     choiceToBlur:(BOOL)choiceToBlur
                     compressSize:(CGSize)compressSize
                      placeholder:(UIImage *)placeholder
                       blurRadius:(CGFloat)blurRadius
                        tintColor:(UIColor *)color
            saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       completion:(LKWebImageCompletionBlock)completion;

/**
 增加过度效果显示图片
 
 @param imageURLStr image Url String
 @param placeholder 默认图
 @param completion  完成回调block
 */
- (void)lk_setImageFadeWithURLStr:(NSString *)imageURLStr
                      placeholder:(UIImage *)placeholder
                       completion:(YYWebImageCompletionBlock)completion;
/**
 增加过度效果显示图片

 @param imageURL image Url
 @param placeholder 默认图
 */
- (void)lk_setImageFadeWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder;


/**
 增加过度效果显示图片

 @param imageURL image Url
 @param placeholder  默认图
 @param completion 完成回调block
 */
- (void)lk_setImageFadeWithURL:(NSURL *)imageURL
                   placeholder:(UIImage *)placeholder
                    completion:(YYWebImageCompletionBlock)completion;

/**
 头像黑白化

 @param imageURLStr image Url
 @param placeholder 默认图
 */
- (void)lk_setBlackHeaderWithURLStr:(NSString *)imageURLStr placeholder:(UIImage *)placeholder;

/**
 * @brief clip the cornerRadius with image, UIImageView must be setFrame before, no off-screen-rendered
 */
- (UIImage *)lk_cornerRadiusWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;

@end
