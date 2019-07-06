//
//  UIButton+Helper.m
//  Live
//
//  Created by Heller on 16/3/11.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import "UIButton+Helper.h"
#import <objc/runtime.h>
#import "LVUIUtils.h"

static char const * const LVCustomBadgeTagKey = "LVCustomBadgeObjectTag";

@implementation UIButton (Helper)

@dynamic hitTestEdgeInsets;

static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"HitTestEdgeInsets";

- (void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
    if(value) {
        UIEdgeInsets edgeInsets; [value getValue:&edgeInsets]; return edgeInsets;
    }else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}
- (id)lv_customBadge
{
    return objc_getAssociatedObject(self, LVCustomBadgeTagKey);
}

- (void)setLv_customBadge:(id)newObjectTag
{
    objc_setAssociatedObject(self, LVCustomBadgeTagKey, newObjectTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)lv_displayRedPoint:(BOOL)display
{
    if (!self.lv_customBadge) {
        UIImage *image = [LVUIUtils getRoundImageWithCutOuter:YES Size:(CGSize){8,8} Radius:4 color:[UIColor redColor] withStrokeColor:nil];
        UIImageView *redImageView = [[UIImageView alloc] initWithImage:image];
        self.lv_customBadge = redImageView;
        
        CGSize btnImageSize = self.imageView.image.size;
        
        if (redImageView) {
            redImageView.frame = CGRectMake(0,0,image.size.width,image.size.height);
            redImageView.center = CGPointMake(self.frame.size.width/2+btnImageSize.width - 10, self.frame.size.height/2 - btnImageSize.height + 10);

            [redImageView setUserInteractionEnabled:NO];
            
            [self addSubview:redImageView];
            self.clipsToBounds = NO;
        }
    }
    
    [self.lv_customBadge setHidden:!display];
}

+ (UIButton *)createButton:(UIImage *)normalImg
              highlightImg:(UIImage *)highlightImg
               selectedImg:(UIImage *)selectedImg
                     title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    if(normalImg)
        [button setImage:normalImg forState:UIControlStateNormal];
    if(highlightImg)
        [button setImage:highlightImg forState:UIControlStateHighlighted];
    if(selectedImg)
        [button setImage:selectedImg forState:UIControlStateSelected];
    
    return button;
}

- (void)lv_setUpImageAndDownTitleByMargin:(CGFloat)margin
{
    CGPoint buttonBoundsCenter    = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGPoint endImageViewCenter    = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(self.imageView.bounds));
    CGPoint endTitleLabelCenter   = CGPointMake(buttonBoundsCenter.x,
                                                CGRectGetHeight(self.bounds)-
                                                CGRectGetMidY(self.titleLabel.bounds));
    
    CGPoint startImageViewCenter  = self.imageView.center;
    CGPoint startTitleLabelCenter = self.titleLabel.center;
    CGFloat imageEdgeInsetsTop    = -margin;
    CGFloat imageEdgeInsetsLeft   = endImageViewCenter.x - startImageViewCenter.x;
    CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
    CGFloat imageEdgeInsetsRight  = -imageEdgeInsetsLeft;
    
    self.imageEdgeInsets        = UIEdgeInsetsMake(imageEdgeInsetsTop,
                                                   imageEdgeInsetsLeft,
                                                   imageEdgeInsetsBottom,
                                                   imageEdgeInsetsRight);
    
    CGFloat titleEdgeInsetsTop    = ceilf(fabs(margin)*2)+2;
    CGFloat titleEdgeInsetsLeft   = endTitleLabelCenter.x - startTitleLabelCenter.x;
    CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
    CGFloat titleEdgeInsetsRight  = -titleEdgeInsetsLeft;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop,
                                            titleEdgeInsetsLeft,
                                            titleEdgeInsetsBottom,
                                            titleEdgeInsetsRight);
}

@end
