//
//  LVUIUtils.m
//  Live
//
//  Created by Laka on 16/3/8.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import "LVUIUtils.h"
#import "LKLineView.h"
#import "LKMacros.h"
#import "Masonry.h"
#import "YYKit.h"
#import "CAAnimation+Blocks.h"

/**
 *  圆角蒙版Image 缓存
 */
@interface LVRoundMarkCacheKey : NSObject
@property (nonatomic, assign)CGSize size;
@property (nonatomic, assign)CGFloat radius;
@property (nonatomic, strong)UIColor *color;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong)UIImage *originalImage;

@end

@implementation LVRoundMarkCacheKey
@end

/**
 *  用于拉伸的UIImage图 缓存
 */
@interface LVLineImageCacheKey : NSObject
@property (nonatomic, assign)BOOL isVertical;
@property (nonatomic, assign)BOOL isFirstPixelOpaque;
@property (nonatomic, strong)UIColor *highlightColor;
@property (nonatomic, strong)UIImage *image;
@end
@implementation LVLineImageCacheKey
@end

@implementation LVUIUtils

+ (NSString *)countNumAndChangeformat:(NSString *)text isCurrency:(BOOL)currency
{
    long long num = [text longLongValue];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    if (currency)
    {
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    }
    else
    {
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    
    
    NSString *newAmount = [formatter stringFromNumber:[NSNumber numberWithLong:num]];
    
//    int count = 0;
//    long long int a = num.longLongValue;
//    while (a != 0)
//    {
//        count++;
//        a /= 10;
//    }
//    NSMutableString *string = [NSMutableString stringWithString:num];
//    NSMutableString *newstring = [NSMutableString string];
//    while (count > 3) {
//        count -= 3;
//        NSRange rang = NSMakeRange(string.length - 3, 3);
//        NSString *str = [string substringWithRange:rang];
//        [newstring insertString:str atIndex:0];
//        [newstring insertString:@"," atIndex:0];
//        [string deleteCharactersInRange:rang];
//    }
//    [newstring insertString:string atIndex:0];
    return newAmount;
}

+ (__kindof UIView *) addLineInView:(UIView *)parentView
                                top:(BOOL)isTop
                          lineWidth:(CGFloat)lineWidth
                         leftMargin:(CGFloat)leftMargin
                        rightMargin:(CGFloat)rightMargin{
    
    LKLineView *lineView = [[LKLineView alloc] initGrayLineWithFrame:CGRectMake(0, 0, parentView.width, lineWidth) vertical:NO isFirstPixelOpaque:isTop];
    [parentView addSubview:lineView];
    
    __weak UIView *wParent = parentView;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wParent.mas_left).offset(leftMargin);
        make.right.mas_equalTo(wParent.mas_right).offset(-rightMargin);
        make.height.mas_equalTo(lineWidth);
        if (isTop) {
            make.top.mas_equalTo(wParent.mas_top);
        }else{
            make.bottom.mas_equalTo(wParent.mas_bottom);
        }
    }];
    
    return lineView;
}


+ (__kindof UIView *) addLineInView:(UIView *)parentView
                                top:(BOOL)isTop
                         leftMargin:(CGFloat)leftMargin
                        rightMargin:(CGFloat)rightMargin
{
    return  [self addLineInView:parentView top:isTop lineWidth:1 leftMargin:leftMargin rightMargin:rightMargin];
}

+ (__kindof UIView *) addLineInViewNotUseConstrains:(UIView *)parentView
                                                top:(BOOL)isTop
                                         leftMargin:(CGFloat)leftMargin
                                        rightMargin:(CGFloat)rightMargin
{
    LKLineView *lineView = [[LKLineView alloc] initGrayLineWithFrame:CGRectMake(0, 0, parentView.width, 1) vertical:NO isFirstPixelOpaque:isTop];
    [parentView addSubview:lineView];
    
    lineView.left = leftMargin;
    lineView.width = parentView.width - leftMargin - rightMargin;
    
    if (isTop) {
        lineView.top = 0;
    }else{
        lineView.top = parentView.height - 1;
    }
    
    return lineView;
}

+ (__kindof UIView *) addLineInView:(UIView *)parentView
                              color:(UIColor *)color
                                top:(BOOL)isTop
                         leftMargin:(CGFloat)leftMargin
                        rightMargin:(CGFloat)rightMargin
{
    
    LKLineView *lineView = [[LKLineView alloc] initWithFrame:CGRectMake(0, 0, parentView.width, 1) vertical:NO isFirstPixelOpaque:isTop lineColor:color];
    [parentView addSubview:lineView];
    
    __weak UIView *wParent = parentView;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wParent.mas_left).offset(leftMargin);
        make.right.mas_equalTo(wParent.mas_right).offset(-rightMargin);
        make.height.mas_equalTo(@1);
        if (isTop) {
            make.top.mas_equalTo(wParent.mas_top);
        }else{
            make.bottom.mas_equalTo(wParent.mas_bottom);
        }
    }];
    
    return lineView;
    
}

+ (__kindof UIView *) addVerticalLineInView:(UIView *)parentView
                                      right:(BOOL)isRight
                                  topMargin:(CGFloat)topMargin
                               bottomMargin:(CGFloat)bottomMargin
{
    LKLineView *line = [[LKLineView alloc] initGrayLineWithFrame:CGRectMake(0, 0, 1, parentView.height) vertical:YES isFirstPixelOpaque:!isRight];
    [parentView addSubview:line];
    
    __weak UIView *wParent = parentView;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wParent.mas_top).offset(topMargin);
        make.bottom.mas_equalTo(wParent.mas_bottom).offset(-bottomMargin);
        if (isRight) {
            make.right.mas_equalTo(wParent.mas_right);
        }else{
            make.left.mas_equalTo(wParent.mas_left);
        }
        make.width.mas_equalTo(@1);
    }];
    
    return line;
}

+ (__kindof UIView *) addVerticalLineInView:(UIView *)parentView
                                      right:(BOOL)isRight
                                      color:(UIColor *)color
                                  topMargin:(CGFloat)topMargin
                               bottomMargin:(CGFloat)bottomMargin
{
    LKLineView *line = [[LKLineView alloc] initWithFrame:CGRectMake(0, 0, 1, parentView.height) vertical:YES isFirstPixelOpaque:!isRight lineColor:color];
    [parentView addSubview:line];
    
    __weak UIView *wParent = parentView;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wParent.mas_top).offset(topMargin);
        make.bottom.mas_equalTo(wParent.mas_bottom).offset(-bottomMargin);
        if (isRight) {
            make.right.mas_equalTo(wParent.mas_right).offset(0.5);
        }else{
            make.left.mas_equalTo(wParent.mas_left);
        }
        make.width.mas_equalTo(@1);
    }];
    
    return line;
}

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
                         highlightColor:(UIColor *)highlightColor
{
    static NSMutableArray *cacheArray = nil;
    
    UIImage *retImage = nil;
    LVLineImageCacheKey *cacheKey = nil;
    
    if(cacheArray) cacheArray = [NSMutableArray new];
    
    for(LVLineImageCacheKey *tmp in cacheArray)
    {
        if((tmp.isVertical == isVertical) &&
           (tmp.highlightColor == highlightColor) &&
           (tmp.isFirstPixelOpaque == isFirstOpaque))
        {
            cacheKey = tmp;
            break;
        }
    }
    
    if(!cacheKey)
    {
        CGSize vSize = isVertical?(CGSize){2, 1}:(CGSize){1, 2};
        
        UIGraphicsBeginImageContext(vSize);
        
        //创建路径并获取句柄
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGFloat leftMargin = isVertical&&!isFirstOpaque ? 1:0;
        CGFloat topMargin = !isVertical&&!isFirstOpaque ? 1:0;
        
        //指定矩形
        CGRect rectangle = (CGRect){leftMargin,topMargin, 1, 1};
        
        //将矩形添加到路径中
        CGPathAddRect(path,NULL, rectangle);
        
        //获取上下文
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        
        //将路径添加到上下文
        CGContextAddPath(currentContext,path);
        
        //设置矩形填充色
        [highlightColor setFill];
        
        //矩形边框颜色
        [[UIColor clearColor] setStroke];
        
        //绘制
        CGContextDrawPath(currentContext,kCGPathFillStroke);
        
        CGPathRelease(path);
        
        retImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        cacheKey = [LVLineImageCacheKey new];
        cacheKey.isVertical = isVertical;
        cacheKey.isFirstPixelOpaque = isFirstOpaque;
        cacheKey.highlightColor = highlightColor;
        cacheKey.image = retImage;
        
        [cacheArray addObject:cacheKey];
    }
    else
    {
        retImage = cacheKey.image;
    }
    
    return retImage;
}

+ (UIColor *)getColorOfPercent:(CGFloat)percent between:(UIColor *)color1 and:(UIColor *)color2
{
    CGFloat red1, green1, blue1, alpha1;
    [color1 getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    
    CGFloat red2, green2, blue2, alpha2;
    [color2 getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    
    CGFloat p1 = percent;
    CGFloat p2 = 1.0 - percent;
    UIColor *mid = [UIColor colorWithRed:red1*p1+red2*p2 green:green1*p1+green2*p2 blue:blue1*p1+blue2*p2 alpha:1.0f];
    return mid;
}

/**
 *  获得某个范围内的屏幕图像
 *
 *  @param theView View
 *  @param frame   frame
 *
 *  @return Image
 */
+ (UIImage *)getImageFromView:(UIView *)theView atFrame:(CGRect)frame
{
    NSParameterAssert(theView);
    
    UIGraphicsBeginImageContextWithOptions(theView.frame.size, NO, [UIScreen mainScreen].scale);
    //    if (IOS7) {
    //        [theView drawViewHierarchyInRect:theView.bounds afterScreenUpdates:YES];
    //    }else {
    //        theView.layer.contentsScale = [UIScreen mainScreen].scale;
    //        [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    //    }
    
    theView.layer.contentsScale = [UIScreen mainScreen].scale;
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    theImage = [self clipRoundImageWithImage:theImage
                                       frame:CGRectMake(0, 0, frame.size.width, frame.size.height)
                                      Radius:theView.layer.cornerRadius
                                 StrokeColor:[UIColor clearColor]];
    
    return theImage;
}

/**
 *  UIView提取Image
 *
 *  @param theView View
 *
 *  @return Image
 */
+ (UIImage *)getImageFromView:(UIView *)theView
{
    UIImage *img = nil;
    if(!CGSizeEqualToSize(theView.frame.size, CGSizeZero))
    {
        UIGraphicsBeginImageContextWithOptions(theView.frame.size, NO, [UIScreen mainScreen].scale);
        if(![theView drawViewHierarchyInRect:theView.bounds afterScreenUpdates:YES]) {
            theView.layer.contentsScale = [UIScreen mainScreen].scale;
            [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
        }
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return img;
}

+ (UIImage *)getImageFromView:(UIView *)theView scale:(CGFloat)scale
{
    UIImage *img = nil;
    if(!CGSizeEqualToSize(theView.frame.size, CGSizeZero))
    {
        UIGraphicsBeginImageContextWithOptions(theView.frame.size, NO, scale);
        if(![theView drawViewHierarchyInRect:theView.bounds afterScreenUpdates:YES]) {
            theView.layer.contentsScale = scale;
            [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
        }
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return img;
}

+ (UIImage*) clipRoundImageWithImage:(UIImage*)origImage
                               frame:(CGRect)frame
                              Radius:(CGFloat)r
                         StrokeColor:(UIColor *)strokeColor
{
    if (!origImage || CGSizeEqualToSize(origImage.size, CGSizeZero)) {
        return nil;
    }
    
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:r];
    UIBezierPath *roundPath = clipPath;
    
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);
    {
        clipPath.usesEvenOddFillRule = YES;
        
        if (strokeColor) {
            [roundPath setLineWidth:1.0f];
            [strokeColor set];
            [roundPath stroke];
        }
    }
    [clipPath addClip];
    
    [origImage drawInRect:CGRectMake(0, 0, origImage.size.width, origImage.size.height)];
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}


/**
 *  @brief  裁剪出无锯齿圆角 Cover
 *
 *  @param orig         原始图片
 *  @param r            半径
 *  @param strokeColor  描边颜色
 *
 *  @return 裁剪后得到的无锯齿圆角 Cover
 */
+ (UIImage*) clipRoundImageWithImage:(UIImage*)origImage
                            CutOuter:(BOOL)isCutOuter
                              Radius:(CGFloat)r
                         StrokeColor:(UIColor *)strokeColor
{
    if (!origImage || CGSizeEqualToSize(origImage.size, CGSizeZero)) {
        return nil;
    }
    
    CGRect rect = (CGRect){CGPointZero, origImage.size};
    
    UIBezierPath *clipPath = nil;
    UIBezierPath *roundPath = nil;
    
    if (isCutOuter) {
        clipPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:r];
        roundPath = clipPath;
    }else{
        clipPath = [UIBezierPath bezierPathWithRect:CGRectInfinite];
        roundPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:r];
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

+ (UIImage*) clipRoundImageWithImage:(UIImage*)origImage
                            CutOuter:(BOOL)isCutOuter
                              Radius:(CGFloat)r
                         StrokeColor:(UIColor *)strokeColor
                     StrokeLineWidth:(CGFloat)lineWidth
{
    
    if (!origImage || CGSizeEqualToSize(origImage.size, CGSizeZero)) {
        return nil;
    }
    
    CGRect rect = (CGRect){CGPointZero, origImage.size};
    
    UIBezierPath *clipPath = nil;
    UIBezierPath *roundPath = nil;
    
    if (isCutOuter) {
        clipPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:r];
        roundPath = clipPath;
    }else{
        clipPath = [UIBezierPath bezierPathWithRect:CGRectInfinite];
        roundPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:r];
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
            [roundPath setLineWidth:lineWidth];
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

+ (UIImage *)getCentetModeDefaultImage:(UIImage *)defaultImage newSize:(CGSize)size
{
    static NSMutableArray *cacheArray = nil;
    LVRoundMarkCacheKey *cacheKey = nil;
    
    if(!cacheArray) cacheArray = [NSMutableArray new];
    
    for(LVRoundMarkCacheKey *tmp in cacheArray)
    {
        if(CGSizeEqualToSize(tmp.size, size) && [defaultImage isEqual:tmp.originalImage])
        {
            cacheKey = tmp;
            break;
        }
    }
    
    if (!cacheKey) {
        
        UIImage *retImage = [defaultImage imageByResizeToSize:size contentMode:UIViewContentModeCenter];
        
        cacheKey = [LVRoundMarkCacheKey new];
        cacheKey.size = size;
        cacheKey.image = retImage;
        cacheKey.originalImage = defaultImage;

        [cacheArray addObject:cacheKey];
    }
    
    return cacheKey.image;
}

+ (UIImage *)getRoundImageWithCutOuter:(BOOL)isCutOuter
                                  Size:(CGSize)size
                                Radius:(CGFloat)radius
                                 color:(UIColor *)color
                       withStrokeColor:(UIColor *)strokeColor
{
    static NSMutableArray *cacheArray = nil;
    UIImage *retImage =  nil;
    LVRoundMarkCacheKey *cacheKey = nil;
    
    if(!cacheArray) cacheArray = [NSMutableArray new];
    
    for(LVRoundMarkCacheKey *tmp in cacheArray)
    {
        if((CGSizeEqualToSize(tmp.size, size)) &&
           (tmp.radius == radius) &&
           ([tmp.color isEqual:color]))
        {
            cacheKey = tmp;
            break;
        }
    }
    
    if(!cacheKey)
    {
        UIView *roundView = [UIView new];
        roundView.backgroundColor = color;
        [roundView setFrame:(CGRect){0,0,size.width+2, size.height+2}];
        
        retImage = [self getImageFromView:roundView atFrame:(CGRect){0, 0, size}];
        retImage = [self clipRoundImageWithImage:retImage CutOuter:isCutOuter Radius:radius StrokeColor:strokeColor];
        
        cacheKey = [LVRoundMarkCacheKey new];
        cacheKey.size = size;
        cacheKey.radius = radius;
        cacheKey.color = color;
        cacheKey.image = retImage;
        
        [cacheArray addObject:cacheKey];
    }
    else
    {
        retImage = cacheKey.image;
    }
    
    return retImage;
}

+ (UIImage *)getImageWithRoundingCorners:(UIRectCorner)corners
                            cornerRadius:(CGFloat)radius
                                    size:(CGSize)size
                         backgroundcolor:(UIColor *)backgroundcolor
                             strokeColor:(UIColor *)strokeColor
                               lineWidth:(CGFloat)lineWidth
{
    UIImage *retImage =  nil;
    UIImage *originImage = [UIImage imageWithColor:backgroundcolor size:size];
    UIBezierPath * clipPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height)
                                                    byRoundingCorners:corners
                                                          cornerRadii:CGSizeMake(radius, radius)];
    
    retImage = [self clipImageWithOrigImage:originImage
                                   CutOuter:YES
                                   ClipPath:clipPath
                               CornerRadius:radius
                                      Color:backgroundcolor
                                StrokeColor:strokeColor
                                  LineWidth:lineWidth];
    
    return retImage;
}

//LSYLubtitleView 有使用
+ (UIImage *)clipImageWithRoundingCorners:(UIRectCorner)corners
                                  ForView:(UIView*)view
                             CornerRadius:(CGFloat)radius
                                    Color:(UIColor *)color
                              StrokeColor:(UIColor *)strokeColor
                                LineWidth:(CGFloat)lineWidth
{
    
    UIImage *retImage =  nil;
    UIView *roundView = [UIView new];
    roundView.backgroundColor = color;
    [roundView setFrame:view.bounds];
    
    retImage = [self getImageFromView:roundView atFrame:roundView.bounds];
    
    UIBezierPath * clipPath = [UIBezierPath bezierPathWithRoundedRect:roundView.frame
                                                    byRoundingCorners:corners
                                                          cornerRadii:CGSizeMake(radius, radius)];
    
    retImage = [self clipImageWithOrigImage:retImage
                                   CutOuter:YES
                                   ClipPath:clipPath
                               CornerRadius:radius
                                      Color:color
                                StrokeColor:strokeColor
                                  LineWidth:lineWidth];
    
    retImage = [self clipImageWithOrigImage:retImage
                                   CutOuter:NO
                                   ClipPath:clipPath
                               CornerRadius:radius
                                      Color:color
                                StrokeColor:strokeColor
                                  LineWidth:lineWidth];
    
    return retImage;
}

+ (UIImage *)clipImageWithOrigImage:(UIImage *)origImage
                           CutOuter:(BOOL)isCutOuter
                           ClipPath:(UIBezierPath *)clipPath
                       CornerRadius:(CGFloat)radius
                              Color:(UIColor *)color
                        StrokeColor:(UIColor *)strokeColor
                          LineWidth:(CGFloat)lineWidth
{
    if (!origImage || CGSizeEqualToSize(origImage.size, CGSizeZero)) {
        return nil;
    }
    
    CGRect rect = (CGRect){CGPointZero, origImage.size};
    
    UIBezierPath *outPath = [UIBezierPath bezierPathWithRect:CGRectInfinite];
    
    if (!isCutOuter) {
        [outPath appendPath:clipPath];
    }
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    {
        clipPath.usesEvenOddFillRule = YES;
        
        if (!isCutOuter) {
            [[UIColor clearColor] setFill];
            [outPath fill];
        }
        
        if (strokeColor && isCutOuter) {
            [clipPath setLineWidth:lineWidth];
            [strokeColor set];
            [clipPath stroke];
        }
    }
    [clipPath addClip];
    
    [origImage drawInRect:rect];
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (CAShapeLayer *)makeShapelayerWithRoundingCorners:(UIRectCorner)corners
                                            forView:(UIView*)view
                                   withCornerRadius:(CGFloat)radius
{
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                      byRoundingCorners:corners
                                                            cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *corBoundmaskLayer = [CAShapeLayer layer];
    corBoundmaskLayer.frame         = view.bounds;
    corBoundmaskLayer.path          = bezierPath.CGPath;
    
    return corBoundmaskLayer;
}

+ (CAShapeLayer *)showCenterHeartAnimationInView:(UIView *)view color:(UIColor *)heartColor
{
    CGRect rect = CGRectMake(view.centerX-10, view.centerY-10, 20, 20);
    
    CAShapeLayer *heartLayer = [LVUIUtils heartShapelayerWithFrame:rect];
    heartLayer.opacity = 0.0f;
    heartLayer.fillColor = heartColor.CGColor;
    [view.layer addSublayer:heartLayer];
    
    CGFloat dScale = view.width/25.0;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @(0.1f);
    scaleAnimation.toValue = @(dScale);
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.0f);
    opacityAnimation.toValue = @(0.0f);

    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, opacityAnimation];
    animation.duration = 0.5;
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    
    @weakify(heartLayer);
    [animation setCompletion:^(BOOL finished) {
        [weak_heartLayer removeFromSuperlayer];
    }];
    
    [heartLayer addAnimation:animation forKey:@"transform.scale"];
    
    return heartLayer;
}

+ (CAShapeLayer *)heartShapelayerWithFrame:(CGRect)frame
{
    UIBezierPath * bezierPath = [LVUIUtils heartShape:frame];
    CAShapeLayer *corBoundmaskLayer = [CAShapeLayer layer];
    corBoundmaskLayer.frame         = frame;
    corBoundmaskLayer.path          = bezierPath.CGPath;
    
    return corBoundmaskLayer;
}

+ (CGRect)maximumSquareFrameThatFits:(CGRect)frame;
{
    CGFloat a = MIN(frame.size.width, frame.size.height);
    return CGRectMake(frame.size.width/2 - a/2, frame.size.height/2 - a/2, a, a);
}

+ (UIBezierPath *)heartShape:(CGRect)originalFrame
{
    CGRect frame = [self maximumSquareFrameThatFits:originalFrame];
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.74182 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.04948 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.49986 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.24129 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.64732 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.05022 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.55044 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.11201 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.33067 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.06393 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.46023 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.14682 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.39785 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.08864 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.25304 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.05011 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.30516 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.05454 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.27896 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.04999 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.00841 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36081 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.12805 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.05067 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.00977 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.15998 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.29627 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.70379 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.00709 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.55420 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.18069 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62648 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50061 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.92498 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.40835 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.77876 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.48812 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.88133 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.70195 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.70407 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.50990 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.88158 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.59821 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.77912 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.99177 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35870 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.81539 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62200 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.99308 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.55208 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.74182 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.04948 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.99040 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.15672 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.86824 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.04848 * CGRectGetHeight(frame))];
    [bezierPath closePath];
    bezierPath.miterLimit = 4;
    
    return bezierPath;
}

@end
