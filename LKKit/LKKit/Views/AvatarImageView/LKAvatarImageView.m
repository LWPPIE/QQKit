//
//  LKAvatarImageView.m
//  LKNovelty
//
//  Created by RoyLei on 16/12/8.
//  Copyright © 2016年 Laka. All rights reserved.
//

#import "LKAvatarImageView.h"

#import "LKMacros.h"
#import "LVUIUtils.h"
#import "LSYConstance.h"
#import <YYKit/UIView+YYAdd.h>
#import <YYKit/UIColor+YYAdd.h>
#import "UIImageView+LKWebImage.h"

@interface LKAvatarImageView()

@property (strong, nonatomic) UIImageView  *bgMarkView;
@property (strong, nonatomic) UIImageView  *coverImageView;
@property (strong, nonatomic) CAShapeLayer *maskLayer;

@end

@implementation LKAvatarImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _maskLayer = [CAShapeLayer layer];
        self.layer.mask = _maskLayer;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_bgMarkView setFrame:self.bounds];
    [_coverImageView setFrame:self.bounds];
    
    _maskLayer.frame = self.bounds;
    _maskLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    
    if (!_bgMarkView.image) {
        UIImage *image = [LVUIUtils getRoundImageWithCutOuter:YES
                                                         Size:self.frame.size
                                                       Radius:self.width/2
                                                        color:[UIColor colorWithWhite:0.0 alpha:0.4f]
                                              withStrokeColor:nil];
        [_bgMarkView setImage:image];
    }
}

- (UIImage *)setPlaceholderImage:(UIImage *)placeholder
{
    [self setImage:placeholder];
    return placeholder;
}

#pragma mark - Public

- (void)lk_setRoundAvatarImageWithURLStr:(NSString *)imageURLStr placeholder:(UIImage *)placeholder
{
    [self lk_setImageFadeWithURLStr:imageURLStr placeholder:placeholder];
}

#pragma mark - Touch Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [UIView animateWithDuration:0.05 animations:^{
        [_bgMarkView setAlpha:1.0];
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [UIView animateWithDuration:0.2f animations:^{
        [_bgMarkView setAlpha:0.0f];
    }];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    [UIView animateWithDuration:0.2f animations:^{
        [_bgMarkView setAlpha:0.0f];
    }];
}

#pragma mark - Getter

- (UIView *)bgMarkView
{
    if (!_bgMarkView) {
        UIImageView *bgMarkView = [[UIImageView alloc] initWithFrame:self.bounds];
        [bgMarkView setAlpha:0.0f];
        [bgMarkView setHidden:YES];
        [self addSubview:bgMarkView];
        
        _bgMarkView = bgMarkView;
    }
    
    return _bgMarkView;
}

- (UIImageView *)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_coverImageView setImage:LKImage(@"home_avatar_line_cover")];
        [_coverImageView setHidden:YES];
        [self addSubview:_coverImageView];
    }
    
    return _coverImageView;
}
@end
