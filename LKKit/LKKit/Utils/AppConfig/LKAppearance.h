//
//  LKAppearance.h
//  LKKit
//
//  Created by RoyLei on 16/12/17.
//  Copyright © 2016年 RoyLei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKAppearance : NSObject

@property (strong, nonatomic) UIColor *mainColor;  /**< 主色调 */
@property (strong, nonatomic) UIColor *mainBGColor;/**< 主背景色 */

+ (instancetype)sharedInstance;

@end
