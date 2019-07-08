//
//  LVConnectStatusInfoView.m
//  Live
//
//  Created by 熙文 张 on 16/3/29.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import "LVConnectStatusInfoView.h"

#import "LSYConstance.h"
#import "UIView+YYAdd.h"
#import "YYCGUtilities.h"
#import "LKMacros.h"
#import "Masonry.h"
#import "LVUIUtils.h"

@interface LVConnectStatusInfoView ()

@end

@implementation LVConnectStatusInfoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    [self setBackgroundColor:[UIColor blackColor]];
    [self setUserInteractionEnabled:YES];
    
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 120)];
    [self addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(120);
    }];
    
    [centerView addSubview:[self infoImageView]];
    [centerView addSubview:[self infoLabel]];
    
    [_infoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(centerView.mas_centerX);
    }];
    
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(centerView.mas_centerX);
        make.top.mas_equalTo(_infoImageView.mas_bottom).with.offset(19);
        make.height.mas_equalTo(18);
    }];
}

#pragma mark - Getter

- (UIImageView *)infoImageView
{
    if (!_infoImageView)
    {
        _infoImageView = [UIImageView new];
        [_infoImageView setContentMode:UIViewContentModeCenter];
    }
    
    return _infoImageView;
}

- (UILabel *)infoLabel
{
    if (!_infoLabel)
    {
        _infoLabel = [[UILabel alloc] init];
        [_infoLabel setTextAlignment:NSTextAlignmentCenter];
        [_infoLabel setFont:[UIFont systemFontOfSize:14]];
        [_infoLabel setTextColor:UIColorWithHex(0xffffff)];
    }
    
    return _infoLabel;
}

@end
