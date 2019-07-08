//
//  LKUIHelper.m
//  Live
//
//  Created by RoyLei on 2017/5/26.
//  Copyright © 2017年 LaKa. All rights reserved.
//

#import "LKUIHelper.h"
#import "LKCacheManager.h"
#import "LVUIUtils.h"

@implementation LKUIHelper

+ (UIImage *)imageWithImage:(UIImage*)image
               scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)compressByImage:(UIImage *)image
{
    return [self compressByImage:image containerSize:CGSizeMake(1280.0, 1080.0) compressRate:0.75];
}

+ (UIImage *)compressForBlurByImage:(UIImage *)image
{
    return [self compressByImage:image containerSize:CGSizeMake(320.0, 568.0) compressRate:0.5];
}

+ (UIImage *)compressByImage:(UIImage *)image
               containerSize:(CGSize)defaultSize
                compressRate:(CGFloat)compressRate
{
    if (!image) {
        return nil;
    }
    
    CGSize newSize       = image.size;
    CGFloat defaulWidth  = defaultSize.width;
    CGFloat defaulHeight = defaultSize.height;
    CGFloat compressW    = compressRate;
    CGFloat compressH    = compressRate;
    CGFloat compress     = 1.0f;
    
    if (image.size.width >= defaulWidth && image.size.height >= defaulHeight) {
        
        compressW = defaulWidth/image.size.width;
        compressH = defaulHeight/image.size.height;
        compress = MIN(compressW, compressH);
        
    } else if (image.size.width >= defaulHeight && image.size.height >= defaulWidth) {
        
        compressW = defaulHeight/image.size.width;
        compressH = defaulWidth/image.size.height;
        compress = MIN(compressW, compressH);
        
    } else if (image.size.width >= defaulWidth || image.size.width >= defaulHeight ||
               image.size.height >= defaulWidth || image.size.height >= defaulHeight) {
        compress = 0.75;
    }
    
    newSize = CGSizeMake(image.size.width * compress, image.size.height * compress);
    
    //体积压缩
    UIImage *newImage = [LKUIHelper imageWithImage:image scaledToSize:newSize];
    
    return newImage;
}

+ (UIImage *)getRoundImageWithCutOuter:(BOOL)isCutOuter
                               corners:(UIRectCorner)corners
                                  size:(CGSize)size
                                radius:(CGFloat)radius
                       backgroundColor:(UIColor *)backgroundColor
{
    NSString *saveKey = [NSString stringWithFormat:@"RoundImage:%@_%@_%@_%@_%@_%@",
                         NSStringFromCGSize(size),
                         @(isCutOuter),
                         @(radius),
                         @(corners),
                         @(radius),
                         [backgroundColor hexString]];
    
    UIImage *retImage = (UIImage *)[LKCanCleanCache() objectForKey:saveKey];
    if (retImage) {
        return retImage;
    }else {
        UIView *roundView = [UIView new];
        roundView.backgroundColor = backgroundColor;
        [roundView setFrame:(CGRect){0,0,size.width+2, size.height+2}];
        
        retImage = [LVUIUtils getImageFromView:roundView atFrame:(CGRect){0, 0, size}];
        retImage = [self clipImageWithOriginalImage:retImage
                                           cutOuter:isCutOuter
                                            corners:corners
                                             radius:radius
                                        strokeColor:nil
                                          lineWidth:0];

        [LKCanCleanCache() setObject:retImage forKey:saveKey];
    }

    return retImage;
}

+ (UIImage *)clipImageWithOriginalImage:(UIImage *)origImage
                               cutOuter:(BOOL)isCutOuter
                                corners:(UIRectCorner)corners
                                 radius:(CGFloat)radius
                            strokeColor:(UIColor *)strokeColor
                              lineWidth:(CGFloat)lineWidth
{
    if (!origImage || CGSizeEqualToSize(origImage.size, CGSizeZero)) {
        return nil;
    }
    
    CGRect rect = (CGRect){CGPointZero, origImage.size};
    
    UIBezierPath *roundPath = nil;
    UIBezierPath *clipPath = nil;
    
    if (isCutOuter) {
        clipPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                         byRoundingCorners:corners
                                               cornerRadii:CGSizeMake(radius, radius)];
        roundPath = clipPath;
    }else{
        clipPath = [UIBezierPath bezierPathWithRect:CGRectInfinite];
        roundPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                          byRoundingCorners:corners
                                                cornerRadii:CGSizeMake(radius, radius)];
        [clipPath appendPath:roundPath];
    }
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    {
        clipPath.usesEvenOddFillRule = YES;
        
        if (!isCutOuter) {
            [UIColor.clearColor setFill];
            [roundPath fill];
        }
        
        if (strokeColor) {
            [roundPath setLineWidth:2.0f];
            [strokeColor set];
            [roundPath stroke];
        }
    }
    [clipPath addClip];
    
    [origImage drawInRect:rect];
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end
