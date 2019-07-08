//
//  LKCircleLoadingView.h
//  Pods
//
//  Created by RoyLei on 16/11/25.
//
//

#import <UIKit/UIKit.h>

@interface LKCircleLoadingView : UIView

@property (strong, nonatomic, readonly) UIImageView *circleImageView;
@property (strong, nonatomic, readonly) UIView      *maskView;

- (void)startAnimation;

- (void)stopAnimation;

@end
