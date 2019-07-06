//
//  UIImageView+LKWebImage.m
//  Pods
//
//  Created by RoyLei on 16/11/15.
//
//

#import "UIImageView+LKWebImage.h"
#import <YYKit/YYCGUtilities.h>
#import "UIImage+ImageEffects.h"
#import "LKMacros.h"
#import "LSYConstance.h"
#import "UIDevice+LKAdd.h"
#import "UIColor+YYAdd.h"
#import "LKUIHelper.h"

@implementation UIImageView(LKWebImage)

#pragma mark - Set Blur Image Fade Animation

- (void)lk_setImageFadeAndBlurWithURLStr:(NSString *)imageURLStr placeholder:(UIImage *)placeholder
{
    [self lk_setBlurImageWithURLStr:imageURLStr
                      fadeAnimation:YES
                       choiceToBlur:NO
                       compressSize:CGSizeMake(60, 60)
                        placeholder:placeholder
                         blurRadius:12
                          tintColor:UIColorHexAndAlpha(0x000000, 0.4)
              saturationDeltaFactor:1.1
                         completion:nil];
}

- (void)lk_setImageFadeAndBlurWithURLStr:(NSString *)imageURLStr
                           blurImageView:(UIImageView *)blurImageView
                             placeholder:(UIImage *)placeholder
{
    WS(weakSelf)
    [self lk_setBlurImageWithURLStr:imageURLStr
                      fadeAnimation:NO
                       choiceToBlur:YES
                       compressSize:CGSizeMake(60, 60)
                        placeholder:placeholder
                         blurRadius:12
                          tintColor:UIColorHexAndAlpha(0x000000, 0.4)
              saturationDeltaFactor:1.1
                         completion:^(UIImage * _Nullable image, UIImage * _Nullable effectImage, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                             
                             if (image) {
                                 [weakSelf setImage:image];
                             }
                             
                             if (effectImage) {
                                 [blurImageView setImage:effectImage];
                             }
                             
                             if (image && from == YYWebImageFromRemote) {
                                 [weakSelf doanimationWithImage:image placeholder:placeholder];
                             }
                             
                         }];
}

- (void)lk_setImageFadeAndBlurWithURLStr:(NSString *)imageURLStr
                            compressSize:(CGSize)compressSize
                             placeholder:(UIImage *)placeholder
{
    [self lk_setBlurImageWithURLStr:imageURLStr
                      fadeAnimation:YES
                       choiceToBlur:NO
                       compressSize:compressSize
                        placeholder:placeholder
                         blurRadius:12
                          tintColor:UIColorHexAndAlpha(0x000000, 0.4)
              saturationDeltaFactor:1.1
                         completion:nil];
}

- (void)lk_setBlurImageWithURLStr:(NSString *)imageURLStr
                    fadeAnimation:(BOOL)fadeAnimation
                     choiceToBlur:(BOOL)choiceToBlur
                     compressSize:(CGSize)compressSize
                      placeholder:(UIImage *)placeholder
                       blurRadius:(CGFloat)blurRadius
                        tintColor:(UIColor *)color
            saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       completion:(LKWebImageCompletionBlock)completion
{
    NSURL *url = [NSURL URLWithString:imageURLStr];

    __block NSString *effectImageURL = [NSString stringWithFormat:@"%@_blur_compressSize_%@_radius_%@_color_%@_factor_@%",
                                        NSStringFromCGSize(compressSize),imageURLStr, @(blurRadius), [color hexString], @(saturationDeltaFactor)];
    UIImage *cacheImage = [[YYWebImageManager sharedManager].cache getImageForKey:effectImageURL
                                                                         withType:YYImageCacheTypeAll];
    
    if (cacheImage) {
        UIImage *orignalImage = [[YYWebImageManager sharedManager].cache getImageForKey:[[YYWebImageManager sharedManager] cacheKeyForURL:url]
                                                                             withType:YYImageCacheTypeAll];
        self.image = cacheImage;
        
        if (completion) {
            completion(orignalImage, cacheImage, url, YYWebImageFromDiskCache, YYWebImageStageFinished, nil);
        }
        
        return;
    }
    
    WS(weakSelf)
    [self setImageWithURL:url
              placeholder:placeholder
                  options:YYWebImageOptionAvoidSetImage
               completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error)
     {
         
         if (!image) {
             if (completion) {
                 completion(image, nil, url, from, stage, error);
             }
             
             return;
         }
         
         // 是否选择性模糊化，如果返回的图片长宽比和当前ImageView的一致则不显示模糊化背景, 此处主要用于精彩视频模糊背景选择性显示
         if (choiceToBlur && image && self.frame.size.height > 1.0) {
             
             CGFloat width = image.size.width / image.size.height * self.frame.size.height;
             
             if (width >= self.frame.size.width) {
                 if (completion) {
                     completion(image, nil, url, from, stage, error);
                 }
                 return;
             }
         }
         
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             
             UIImage *effectImage = nil;
             
             if(image) {
                 
                 UIImage *compressImage = [LKUIHelper compressByImage:image containerSize:compressSize compressRate:0.6];
                 
                 effectImage = [compressImage applyBlurWithRadius:blurRadius
                                                        tintColor:color
                                            saturationDeltaFactor:saturationDeltaFactor
                                                        maskImage:nil];
                 
                 [[YYWebImageManager sharedManager].cache setImage:effectImage
                                                         imageData:nil
                                                            forKey:effectImageURL
                                                          withType:YYImageCacheTypeAll];
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 if (completion) {
                     completion(image, effectImage, url, from, stage, error);
                 }
                 
                 if (fadeAnimation && effectImage && from == YYWebImageFromRemote) {
                     [weakSelf doanimationWithImage:effectImage placeholder:placeholder];
                 }
             });
             
         });
     }];
}

#pragma mark - Set Image Fade Animation

- (void)lk_setImageFadeWithURLStr:(NSString *)imageURLStr
{
    NSURL *imageURL = [NSURL URLWithString:imageURLStr];
    
    [self lk_setImageFadeWithURL:imageURL
                     placeholder:nil
                         options:YYWebImageOptionAvoidSetImage
                         manager:nil
                        progress:nil
                       transform:nil
                      completion:nil];
}

- (void)lk_setImageFadeAndBlurWithURLStr:(NSString *)imageURLStr
{
    [self lk_setImageFadeAndBlurWithURLStr:imageURLStr placeholder:nil];
}

- (void)lk_setImageFadeWithURLStr:(NSString *)imageURLStr placeholder:(UIImage *)placeholder
{
    NSURL *imageURL = [NSURL URLWithString:imageURLStr];
    
    [self lk_setImageFadeWithURL:imageURL
                     placeholder:placeholder
                         options:YYWebImageOptionAvoidSetImage
                         manager:nil
                        progress:nil
                       transform:nil
                      completion:nil];
}

- (void)lk_setImageFadeWithURLStr:(NSString *)imageURLStr
                      placeholder:(UIImage *)placeholder
                       completion:(YYWebImageCompletionBlock)completion
{
    NSURL *imageURL = [NSURL URLWithString:imageURLStr];

    [self lk_setImageFadeWithURL:imageURL
                     placeholder:placeholder
                         options:YYWebImageOptionAvoidSetImage
                         manager:nil
                        progress:nil
                       transform:nil
                      completion:completion];
}

- (void)lk_setImageFadeWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder
{
    [self lk_setImageFadeWithURL:imageURL
                     placeholder:placeholder
                         options:YYWebImageOptionAvoidSetImage
                         manager:nil
                        progress:nil
                       transform:nil
                      completion:nil];
}
    
- (void)lk_setImageFadeWithURL:(NSURL *)imageURL
                   placeholder:(UIImage *)placeholder
                    completion:(YYWebImageCompletionBlock)completion
{
    [self lk_setImageFadeWithURL:imageURL
                     placeholder:placeholder
                         options:YYWebImageOptionAvoidSetImage
                         manager:nil
                        progress:nil
                       transform:nil
                      completion:completion];
    
}
    
- (void)lk_setImageFadeWithURL:(NSURL *)imageURL
                   placeholder:(UIImage *)placeholder
                       options:(YYWebImageOptions)options
                       manager:(YYWebImageManager *)manager
                      progress:(YYWebImageProgressBlock)progress
                     transform:(YYWebImageTransformBlock)transform
                    completion:(YYWebImageCompletionBlock)completion
{
    @weakify(self)
    [self setImageWithURL:imageURL
              placeholder:placeholder
                  options:options
                  manager:manager
                 progress:progress
                transform:transform
               completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                   @strongify(self)
                   
                   if (![UIDevice isOlderThaniPhone5s] && from == YYWebImageFromRemote && image) {
                       [self doanimationWithImage:image placeholder:placeholder];
                   }
                   
                   if(image){
                       [self setImage:image];
                   }

                   if (completion) {
                       completion(image, url, from, stage, error);
                   }
                   
               }];
}

- (void)lk_setBlackHeaderWithURLStr:(NSString *)imageURLStr placeholder:(UIImage *)placeholder;
{
    __block NSString *effectImageURL = [NSString stringWithFormat:@"%@_black_header_effect", imageURLStr];
    UIImage *cacheImage = [[YYWebImageManager sharedManager].cache getImageForKey:effectImageURL
                                                                         withType:YYImageCacheTypeAll];
    
    if (cacheImage) {
        self.image = cacheImage;
        return;
    }
    
    cacheImage = [[YYWebImageManager sharedManager].cache getImageForKey:imageURLStr
                                                                withType:YYImageCacheTypeAll];
    
    if (cacheImage) {
        
        UIImage *effectImage = [cacheImage lk_convertImageToGreyScale];
        
        [[YYWebImageManager sharedManager].cache setImage:effectImage
                                                imageData:nil
                                                   forKey:effectImageURL
                                                 withType:YYImageCacheTypeAll];
        
        [self setImage:effectImage];
        return;
    }
    
    WS(weakSelf)
    NSURL *url = [NSURL URLWithString:imageURLStr];
    [self setImageWithURL:url
              placeholder:placeholder
                  options:YYWebImageOptionAvoidSetImage
               completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error)
     {
         UIImage *effectImage = nil;
         if(image) {
             
             effectImage = [image lk_convertImageToGreyScale];
             
             [[YYWebImageManager sharedManager].cache setImage:effectImage
                                                     imageData:nil
                                                        forKey:effectImageURL
                                                      withType:YYImageCacheTypeAll];
         }
         if (effectImage) {
             weakSelf.image = effectImage;
         }
     }];
}

/**
 * @brief clip the cornerRadius with image, UIImageView must be setFrame before, no off-screen-rendered
 */
- (UIImage *)lk_cornerRadiusWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (nil == currentContext) {
        return nil;
    }
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCornerType cornerRadii:cornerRadii];
    [cornerPath addClip];
    [self.layer renderInContext:currentContext];

    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.image = processedImage;
    
    return processedImage;
}

- (void)doanimationWithImage:(UIImage *)image placeholder:(UIImage *)placeholder
{
    if (placeholder) {
        
        CABasicAnimation *contentsAnimation = (CABasicAnimation *)[self.layer animationForKey:@"lk_contentsAnimation"];
        if (!contentsAnimation) {
            contentsAnimation = [CABasicAnimation animationWithKeyPath:@"contents"];
            contentsAnimation.fromValue = (__bridge id)placeholder.CGImage;
            contentsAnimation.toValue = (__bridge id)image.CGImage;
            contentsAnimation.duration = 0.3f;
            contentsAnimation.removedOnCompletion = NO;
            contentsAnimation.fillMode = kCAFillModeForwards;
            
            self.layer.contents = (__bridge id)image.CGImage;
            [self.layer addAnimation:contentsAnimation forKey:@"lk_contentsAnimation"];
        }
        
    }else {
        
        CABasicAnimation *transitionAnimation = (CABasicAnimation *)[self.layer animationForKey:@"LKImageFadeAnimationKey"];
        if (!transitionAnimation) {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionFade;
            [self.layer addAnimation:transition forKey:@"LKImageFadeAnimationKey"];
        }
    }
}

@end
