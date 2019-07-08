//
//  LKBrightnessView.m
//  Pods
//
//  Created by RoyLei on 16/12/7.
//
//

#import "LKBrightnessView.h"
#import "LKMacros.h"
#import "Masonry.h"

@class LKBrightnessView;
static inline NSString *LKBrightnessViewResourcePath(NSString *subPath){
    return [[[NSBundle bundleForClass:[LKBrightnessView class]] resourcePath] stringByAppendingPathComponent:subPath];
}

#define kBrightnessImage  [UIImage imageNamed:LKBrightnessViewResourcePath(@"LKImages.bundle/LKPlayer_brightness")]

@interface LKBrightnessView ()

@property (nonatomic, strong) UIImageView		*backImage;
@property (nonatomic, strong) UILabel			*title;
@property (nonatomic, strong) UIView			*longView;
@property (nonatomic, strong) NSMutableArray	*tipArray;
@property (nonatomic, assign) BOOL				orientationDidChange;

@end

@implementation LKBrightnessView

- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(kDeviceWidth * 0.5, kDeviceHeight * 0.5, 155, 155);
        
        self.layer.cornerRadius  = 10;
        self.layer.masksToBounds = YES;
        
        // 使用UIToolbar实现毛玻璃效果，简单粗暴，支持iOS7+
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
        toolbar.alpha = 0.97;
        [self addSubview:toolbar];
        
        self.backImage = ({
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 79, 76)];
            imgView.image        = kBrightnessImage;
            [self addSubview:imgView];
            imgView;
        });
        
        self.title = ({
            UILabel *title      = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.bounds.size.width, 30)];
            title.font          = [UIFont boldSystemFontOfSize:16];
            title.textColor     = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.00f];
            title.textAlignment = NSTextAlignmentCenter;
            title.text          = @"亮度";
            [self addSubview:title];
            title;
        });
        
        self.longView = ({
            UIView *longView         = [[UIView alloc]initWithFrame:CGRectMake(13, 132, self.bounds.size.width - 26, 7)];
            longView.backgroundColor = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.00f];
            [self addSubview:longView];
            longView;
        });
        
        [self createTips];
        [self addNotification];
        [self addObserver];
        
        self.alpha = 0.0;
    }
    return self;
}

// 创建 Tips
- (void)createTips {
    
    self.tipArray = [NSMutableArray arrayWithCapacity:16];
    
    CGFloat tipW = (self.longView.bounds.size.width - 17) / 16;
    CGFloat tipH = 5;
    CGFloat tipY = 1;
    
    for (int i = 0; i < 16; i++) {
        CGFloat tipX          = i * (tipW + 1) + 1;
        UIImageView *image    = [[UIImageView alloc] init];
        image.backgroundColor = [UIColor whiteColor];
        image.frame           = CGRectMake(tipX, tipY, tipW, tipH);
        [self.longView addSubview:image];
        [self.tipArray addObject:image];
    }
    [self updateLongView:[UIScreen mainScreen].brightness];
}

- (void)showBrightnessView
{
    [self updateLayer:nil];
}

#pragma makr - 通知 KVO

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLayer:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)addObserver {
    
    [[UIScreen mainScreen] addObserver:self
                            forKeyPath:@"brightness"
                               options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    CGFloat sound = [change[@"new"] floatValue];
    [self appearSoundView];
    [self updateLongView:sound];
}

- (void)updateLayer:(NSNotification *)notify {
    self.orientationDidChange = YES;
    
    if (!self.landscapeContainerView) {
        return;
    }
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    
    if (deviceOrientation == UIDeviceOrientationPortrait) {
        
        if ([self isDescendantOfView:[UIApplication sharedApplication].keyWindow]) {
            return;
        }
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(155);
            make.leading.mas_equalTo((kDeviceWidth-155)/2);
            make.top.mas_equalTo((kDeviceHeight-155)/2);
        }];
    } else {
        
        if ([self isDescendantOfView:self.landscapeContainerView]) {
            return;
        }
        
        [self removeFromSuperview];
        [self.landscapeContainerView addSubview:self];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.landscapeContainerView);
            make.width.height.mas_equalTo(155);
        }];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self.landscapeContainerView layoutIfNeeded];
}

#pragma mark - Methond

- (void)appearSoundView {
    if (self.alpha == 0.0) {
        self.orientationDidChange = NO;
        self.alpha = 1.0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self disAppearSoundView];
        });
    }
}

- (void)disAppearSoundView {
    
    if (self.alpha == 1.0) {
        [UIView animateWithDuration:0.4 animations:^{
            self.alpha = 0.0;
        }];
    }
}

#pragma mark - Update View

- (void)updateLongView:(CGFloat)sound {
    CGFloat stage = 1 / 15.0;
    NSInteger level = sound / stage;
    
    for (int i = 0; i < self.tipArray.count; i++) {
        UIImageView *img = self.tipArray[i];
        
        if (i <= level) {
            img.hidden = NO;
        } else {
            img.hidden = YES;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backImage.center = CGPointMake(155 * 0.5, 155 * 0.5);
    self.center = CGPointMake(kDeviceWidth * 0.5, kDeviceHeight * 0.5);
}

- (void)dealloc {
    [[UIScreen mainScreen] removeObserver:self forKeyPath:@"brightness"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
