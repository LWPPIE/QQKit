//
//  LKButton.m
//  LKKit
//
//  Created by RoyLei on 16/11/9.
//  Copyright © 2016年 RoyLei. All rights reserved.
//

#import "LKButton.h"
#import "UIView+YYAdd.h"

@interface LKButton()

@end

@implementation LKButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [self setExclusiveTouch:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    switch (_lvButtonStyle) {
        case LKButtonStyleImageTitleNomarl: {
            break;
        }
        case LKButtonStyleImageTitleVertical: {
            if (self.lsy_isFitTextWidth) {
                CGSize size = [self.titleLabel intrinsicContentSize];
                size.width = MIN(ceilf(size.width), ceilf(self.width));
                [self.titleLabel setSize:size];
            }
            [self.imageView setCenterX:ceilf(self.width/2)];
            [self.titleLabel setCenterX:ceilf(self.imageView.centerX)];
            break;
        }
        default: {
            break;
        }
    }
}

+ (LKButton *)lv_createButton:(UIImage *)normalImg
                 highlightImg:(UIImage *)highlightImg
                  selectedImg:(UIImage *)selectedImg
                        title:(NSString *)title
{
    LKButton *button = [LKButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    if(normalImg)
        [button setImage:normalImg forState:UIControlStateNormal];
    if(highlightImg)
        [button setImage:highlightImg forState:UIControlStateHighlighted];
    if(selectedImg)
        [button setImage:selectedImg forState:UIControlStateSelected];
    
    return button;
}

@end
