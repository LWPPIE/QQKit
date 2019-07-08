//
//  UIView+Create.h
//  shop
//
//  Created by 唐开福 on 16/8/29.
//  Copyright © 2016年 zoomwoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Create)
+ (instancetype)viewFormNib;
@end



@interface UILabel (Create)

+ (instancetype)createLabelWithText:(NSString *)text
                          textColor:(UIColor *)textColor
                           fontSize:(CGFloat)size
                      textAlignment:(NSTextAlignment) textAliment;
@end




@interface UIImageView (Create)

+ (instancetype)createImageWithImageName:(NSString *)imageName
                             contentMode:(UIViewContentMode) contentMode;
@end
