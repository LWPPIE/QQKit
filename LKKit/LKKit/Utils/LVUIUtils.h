//
//  LVUIUtils.h
//  Live
//
//  Created by Laka on 16/3/8.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LVUIUtils : NSObject

/**
 *  金额逗号分割
 *
 *  @param num 金额
 *  @param currency 是否为货币
 *
 *  @return string
 */
+ (NSString *)countNumAndChangeformat:(NSString *)text isCurrency:(BOOL)currency;

/**
 *  生成用于拉伸的UIImage图 (2x1 Or 1*2)像素永久保存内存
 *
 *  @param isVertical      是否垂直拉伸
 *  @param isFirstOpaque   是否第一像素不透明
 *  @param highlightColor  显示的颜色
 *	@param isHighlightLeft 颜色是否显示在左边(横向拉伸时，是否现在在上面)
 *
 *  @return image
 */
+ (UIImage *)getLineImageWithIsVertical:(BOOL)isVertical
                     isFirstPixelOpaque:(BOOL)isFirstOpaque
                         highlightColor:(UIColor *)highlightColor;

+ (__kindof UIView *) addLineInView:(UIView *)parentView
                                top:(BOOL)isTop
                         leftMargin:(CGFloat)leftMargin
                        rightMargin:(CGFloat)rightMargin;

+ (__kindof UIView *) addLineInViewNotUseConstrains:(UIView *)parentView
                                                top:(BOOL)isTop
                                         leftMargin:(CGFloat)leftMargin
                                        rightMargin:(CGFloat)rightMargin;

+ (__kindof UIView *) addLineInView:(UIView *)parentView
                                top:(BOOL)isTop
                          lineWidth:(CGFloat)lineWidth
                         leftMargin:(CGFloat)leftMargin
                        rightMargin:(CGFloat)rightMargin;

+ (__kindof UIView *) addLineInView:(UIView *)parentView
                              color:(UIColor *)color
                                top:(BOOL)isTop
                         leftMargin:(CGFloat)leftMargin
                        rightMargin:(CGFloat)rightMargin;

+ (__kindof UIView *)addVerticalLineInView:(UIView *)parentView
                                     right:(BOOL)isRight
                                 topMargin:(CGFloat)topMargin
                              bottomMargin:(CGFloat)bottomMargin;

+ (__kindof UIView *) addVerticalLineInView:(UIView *)parentView
                                      right:(BOOL)isRight
                                      color:(UIColor *)color
                                  topMargin:(CGFloat)topMargin
                               bottomMargin:(CGFloat)bottomMargin;

+ (UIColor *)getColorOfPercent:(CGFloat)percent between:(UIColor *)color1 and:(UIColor *)color2;

/**
 *  获得某个范围内的屏幕图像
 *
 *  @param theView View
 *  @param frame   frame
 *
 *  @return Image
 */
+ (UIImage *)getImageFromView:(UIView *)theView atFrame:(CGRect)frame;

/**
 *  UIView提取Image
 *
 *  @param theView View
 *
 *  @return Image
 */
+ (UIImage *)getImageFromView:(UIView *)theView;

/**
 *  UIView提取Image
 *
 *  @param theView View
 *  @param scale   缩放值
 *
 *  @return Image
 */
+ (UIImage *)getImageFromView:(UIView *)theView scale:(CGFloat)scale;

/**
 *  @brief  裁剪出无锯齿圆角 Cover
 *  @param origImage    原始图片
 *  @param frame        YES:裁剪大小
 *  @param isCutOuter   YES:裁剪外部 NO:裁剪内部
 *  @param r            半径
 *  @param strokeColor  内框颜色
 *
 *  @return 裁剪后得到的无锯齿圆角 Cover
 */
+ (UIImage*) clipRoundImageWithImage:(UIImage*)origImage
                               frame:(CGRect)frame
                              Radius:(CGFloat)r
                         StrokeColor:(UIColor *)strokeColor;

/**
 *  @brief  裁剪出无锯齿圆角 Cover
 *  @param isCutOuter   YES:裁剪外部 NO:裁剪内部
 *  @param orig         原始图片
 *  @param r            半径
 *  @param strokeColor  内框颜色
 *
 *  @return 裁剪后得到的无锯齿圆角 Cover
 */
+ (UIImage*) clipRoundImageWithImage:(UIImage*)origImage
                            CutOuter:(BOOL)isCutOuter
                              Radius:(CGFloat)r
                         StrokeColor:(UIColor *)strokeColor;

/**
 *  @brief  裁剪出无锯齿圆角 Cover
 *  @param isCutOuter   YES:裁剪外部 NO:裁剪内部
 *  @param orig         原始图片
 *  @param r            半径
 *  @param strokeColor  内框颜色
 *  @param lineWidth    内框线宽
 *
 *  @return 裁剪后得到的无锯齿圆角 Cover
 */
+ (UIImage*) clipRoundImageWithImage:(UIImage*)origImage
                            CutOuter:(BOOL)isCutOuter
                              Radius:(CGFloat)r
                         StrokeColor:(UIColor *)strokeColor
                     StrokeLineWidth:(CGFloat)lineWidth;

/**
 获取默认中心显示Image 永久保存内存

 @param defaultImage 要显示的默认图
 @param size 尺寸
 @return 
 */
+ (UIImage *)getCentetModeDefaultImage:(UIImage *)defaultImage newSize:(CGSize)size;

/**
 *  获取圆角蒙版Image 永久保存内存
 *
 *  @param isCutOuter   YES:裁剪外部 NO:裁剪内部
 *  @param size         大小
 *  @param radius       圆角
 *  @param color        蒙版颜色
 *  @param strokeColor  内框颜色
 *
 *  @return Image
 */
+ (UIImage *)getRoundImageWithCutOuter:(BOOL)isCutOuter
                                  Size:(CGSize)size
                                Radius:(CGFloat)radius
                                 color:(UIColor *)color
                       withStrokeColor:(UIColor *)strokeColor;

/**
 *  获取纯色圆角Image
 *
 *  @param corners         圆角位置
 *  @param radius          圆角半径
 *  @param size            大小
 *  @param backgroundcolor 背景颜色
 *  @param strokeColor     描边颜色
 *  @param lineWidth       描边线段宽度
 */
+ (UIImage *)getImageWithRoundingCorners:(UIRectCorner)corners
                            cornerRadius:(CGFloat)radius
                                    size:(CGSize)size
                         backgroundcolor:(UIColor *)backgroundcolor
                             strokeColor:(UIColor *)strokeColor
                               lineWidth:(CGFloat)lineWidth;

/**
 *  @brief  生成 masklayer
 *
 *  @param corners 那几个圆角
 *  @param view    要设置的View
 *  @param radius  圆角半径
 *
 */
+ (CAShapeLayer *)makeShapelayerWithRoundingCorners:(UIRectCorner)corners
                                            forView:(UIView*)view
                                   withCornerRadius:(CGFloat)radius;

/**
 *  @brief  生成 心形shapeLayer
 *
 *  @param frame  心形shapeLayer的Frame
 *
 */
+ (CAShapeLayer *)heartShapelayerWithFrame:(CGRect)frame;

/**
 View中间显示心形放大动画

 @param view 所在的view
 @param heartColor 心形颜色
 @return 心形CAShapeLayer
 */
+ (CAShapeLayer *)showCenterHeartAnimationInView:(UIView *)view color:(UIColor *)heartColor;

@end
