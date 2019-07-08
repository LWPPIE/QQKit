//
//  LKUIHelper.h
//  Live
//
//  Created by RoyLei on 2017/5/26.
//  Copyright © 2017年 LaKa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKUIHelper : NSObject

/**
 生成新的图片

 @param image 原始图片
 @param newSize 新的尺寸
 @return 新的图片
 */
+ (UIImage *)imageWithImage:(UIImage*)image
               scaledToSize:(CGSize)newSize;

/**
 压缩图片到1080p 以内

 @param image 待压缩图片
 @return 压缩后的图片
 */
+ (UIImage *)compressByImage:(UIImage *)image;

/**
 要模糊化的图片，先做压缩处理

 @param image 要模糊化的图片
 @return 压缩后的图片
 */
+ (UIImage *)compressForBlurByImage:(UIImage *)image;

/**
 对图片做尺寸和质量压缩，并返回

 @param image 原始图片
 @param defaultSize 默认压缩到尺寸容器
 @param compressRate 质量压缩率 0.0 - 1.0
 @return 压缩后的图片
 */
+ (UIImage *)compressByImage:(UIImage *)image
               containerSize:(CGSize)defaultSize
                compressRate:(CGFloat)compressRate;

+ (UIImage *)getRoundImageWithCutOuter:(BOOL)isCutOuter
                               corners:(UIRectCorner)corners
                                  size:(CGSize)size
                                radius:(CGFloat)radius
                       backgroundColor:(UIColor *)backgroundColor;
@end
