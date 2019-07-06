//
//  LKButton.h
//  LKKit
//
//  Created by RoyLei on 16/11/9.
//  Copyright © 2016年 RoyLei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LKButtonStyle){
    LKButtonStyleImageTitleNomarl = 0,
    LKButtonStyleImageTitleVertical = 1,
};

@interface LKButton : UIButton

@property (nonatomic, assign) LKButtonStyle lvButtonStyle;//default is LSYButtonStyleImageTitleNomarl
@property (nonatomic, assign) BOOL lsy_isFitTextWidth;

+ (LKButton *)lv_createButton:(UIImage *)normalImg
                 highlightImg:(UIImage *)highlightImg
                  selectedImg:(UIImage *)selectedImg
                        title:(NSString *)title;

@end
