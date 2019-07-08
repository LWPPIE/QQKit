//
//  LKProgressView.h
//  LKNovelty
//
//  Created by RoyLei on 16/12/3.
//  Copyright © 2016年 Laka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKProgressView : UIImageView

@property (nonatomic, strong, readonly) CAShapeLayer *boxShape;
@property (nonatomic, strong, readonly) CAShapeLayer *circleShape;
@property (nonatomic, strong, readonly) CAShapeLayer *progressShape;

@property (nonatomic, assign) float progress;

@end
