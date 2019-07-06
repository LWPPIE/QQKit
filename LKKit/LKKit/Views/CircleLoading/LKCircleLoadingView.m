//
//  LKCircleLoadingView.m
//  Pods
//
//  Created by RoyLei on 16/11/25.
//
//

#import "LKCircleLoadingView.h"
#import "Masonry.h"
#import "LSYConstance.h"

@class LKCircleLoadingView;
static inline NSString *LKCircleLoadingResourcePath(NSString *subPath){
    return [[[NSBundle bundleForClass:[LKCircleLoadingView class]] resourcePath] stringByAppendingPathComponent:subPath];
}

#define LKCIRCLE_MAGE [UIImage imageNamed:LKCircleLoadingResourcePath(@"LKImages.bundle/public_icon_load")]

@interface LKCircleLoadingView()

@property (strong, nonatomic) UIImageView *circleImageView;
@property (strong, nonatomic) UIView      *maskView;
@end

@implementation LKCircleLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.alpha = 0.0f;
        [self addSubview:self.circleImageView];
        
        [self.circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        self.maskView = [[UIView alloc] initWithFrame:self.bounds];
        [self.maskView setAlpha:0.0f];
        [self.maskView setBackgroundColor:UIColorHexAndAlpha(0x000000, 0.15)];
        [self insertSubview:self.maskView atIndex:0];
        
        [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
    }
    return self;
}

- (void)startAnimation
{
    self.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0f;
    }];
    
    NSString *animationKey = @"LKCircleRotation";
    
    CABasicAnimation *animation = (CABasicAnimation *)[self.circleImageView.layer animationForKey:animationKey];
    if (animation) {
        return;
    }
    
    NSTimeInterval animationDuration = 1;
    CAMediaTimingFunction *linearCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = 0;
    animation.toValue = [NSNumber numberWithFloat:M_PI*2];
    animation.duration = animationDuration;
    animation.timingFunction = linearCurve;
    animation.removedOnCompletion = NO;
    animation.repeatCount = INFINITY;
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = NO;
    
    [self.circleImageView.layer addAnimation:animation forKey:animationKey];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.maskView setAlpha:1.0f];
    }];
}

- (void)stopAnimation
{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self.maskView setAlpha:0.0f];
        [self.circleImageView.layer removeAllAnimations];
    }];
}

#pragma mark - Getter

- (UIImageView *)circleImageView
{
    if (!_circleImageView) {
        _circleImageView = [[UIImageView alloc] initWithImage:LKCIRCLE_MAGE];
        _circleImageView.userInteractionEnabled = YES;
    }
    
    return _circleImageView;
}

@end
