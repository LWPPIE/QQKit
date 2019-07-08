//
//  LVBottomSheetView.m
//  Live
//
//  Created by RoyLei on 16/6/22.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import "LVBottomSheetView.h"
#import "LVShowPopViewHandler.h"
#import "LVUIUtils.h"
#import "LSYConstance.h"
#import "UIView+YYAdd.h"
#import "UIImage+YYAdd.h"
#import "YYCGUtilities.h"
#import "LKMacros.h"
#import "Masonry.h"

@interface LVBottomSheetView()
{
    CGFloat _buttonWidth;
    CGFloat _buttonHeight;
    CGFloat _lastButtonGap;
}

@property (strong, nonatomic) LVShowPopViewHandler *popViewHandler;
@property (strong, nonatomic) LVBottomSheetViewButtonPressedBlock buttonPressedBlock;

@end

@implementation LVBottomSheetView

+ (void)showBottomSheetViewWithButtonTitles:(NSArray <NSString *> *)titles
                              buttonPressed:(LVBottomSheetViewButtonPressedBlock)buttonPressedBlock
{
    LVBottomSheetView *sheetView = [LVBottomSheetView sharedSheetView];
    if(sheetView.popViewHandler) {
        [sheetView.popViewHandler dissmissWithCompletion:^{
            
            [sheetView setButtonTitles:titles];
            sheetView.buttonPressedBlock = buttonPressedBlock;
            
            LVShowPopViewHandler *popViewHandler = [LVShowPopViewHandler showContentView:sheetView
                                                                         inContainerView:[UIApplication sharedApplication].keyWindow
                                                                       useBlurBackground:YES
                                                                                 popType:LVShowPopViewTypeBottom];
            sheetView.popViewHandler = popViewHandler;
        }];
    }else {
        
        [sheetView setButtonTitles:titles];
        sheetView.buttonPressedBlock = buttonPressedBlock;
        
        LVShowPopViewHandler *popViewHandler = [LVShowPopViewHandler showContentView:sheetView
                                                                     inContainerView:[UIApplication sharedApplication].keyWindow
                                                                   useBlurBackground:YES
                                                                             popType:LVShowPopViewTypeBottom];
        sheetView.popViewHandler = popViewHandler;
    }
}

+ (instancetype)sharedSheetView
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:CGRectMake(0, 0, YYScreenSize().width, 0) buttonTitles:nil];
}

- (instancetype)initWithFrame:(CGRect)frame buttonTitles:(NSArray <NSString *> *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _buttonWidth = YYScreenSize().width;
        _buttonHeight = 50;
        _lastButtonGap = 5;
        
        [self setButtonTitles:titles];
        
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.width, 8)];
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = UIColorWithHex(0x000000).CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0f, -2.0f);
        self.layer.shadowOpacity = 0.3f;
        self.layer.shadowPath = shadowPath.CGPath;
        
    }
    return self;
}

- (void)setButtonTitles:(NSArray <NSString *> *)titles
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat viewTotalHeight = titles.count * _buttonHeight + _lastButtonGap + titles.count*1;
    [self setHeight:viewTotalHeight];
    
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *button = [self makeButtonWithTitle:obj];
        [button setTag:idx];
        [self addSubview:button];
        
        if (idx == titles.count - 1) {//last button
            [button setTop:viewTotalHeight - _buttonHeight];
        }else {
            [button setTop:idx*_buttonHeight + idx*1];
//            [LVUIUtils addLineInViewNotUseConstrains:button top:NO leftMargin:0 rightMargin:0];
        }
    }];
    
    [self addExtraViewToTail];
}

- (UIButton *)makeButtonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setSize:CGSizeMake(_buttonWidth, _buttonHeight)];
    [button setBackgroundImage:[UIImage imageWithColor:UIColorHexAndAlpha(0xffffff, 0.75) size:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:UIColorWithHex(0xD6D8DB) size:CGSizeMake(20, 20)] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColorWithHex(0x000000) forState:UIControlStateNormal];
//    [button setTitleColor:UIColorHex(0x000000) forState:UIControlStateHighlighted];
    [button.titleLabel setFont:LKFont(18)];
    
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)addExtraViewToTail
{
    UIView *tailView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 50)];
    [tailView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:tailView];
    [self setClipsToBounds:NO];
}

- (void)buttonPressed:(UIButton *)button
{
    [button setEnabled:NO];
    [self performSelector:@selector(delayEnabledButton:) withObject:button afterDelay:0.4];
    
    [self.popViewHandler dissmiss];
    self.popViewHandler = nil;
    
    if (self.buttonPressedBlock) {
        self.buttonPressedBlock(button.tag, button);
    }
}

- (void)delayEnabledButton:(UIButton *)button
{
    [button setEnabled:YES];
}

- (void)dissmiss
{
    WS(weakSelf)
    [self.popViewHandler dissmissWithCompletion:^{
        weakSelf.popViewHandler = nil;
    }];
}

- (void)dissmissWithCompletion:(void(^)())completion
{
    WS(weakSelf)
    [self.popViewHandler dissmissWithCompletion:^{
        
        weakSelf.popViewHandler = nil;
        
        if (completion) {
            completion();
        }
        
    }];
}

@end
