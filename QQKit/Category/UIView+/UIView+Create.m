//
//  UIView+Create.m
//  shop
//
//  Created by 唐开福 on 16/8/29.
//  Copyright © 2016年 zoomwoo. All rights reserved.
//

#import "UIView+Create.h"

@implementation UIView (Create)
+ (instancetype)viewFormNib{
    NSString *name=NSStringFromClass(self);
    UIView *xibView=[[[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil] firstObject];
    if(xibView==nil){
        NSLog(@"CoreXibView：从xib创建视图失败，当前类是：%@",name);
    }
    return xibView;
}

@end


@implementation UILabel (Create)



+ (instancetype)createLabelWithText:(NSString *)text
                          textColor:(UIColor *)textColor
                           fontSize:(CGFloat)size
                      textAlignment:(NSTextAlignment) textAliment{
    
    UILabel *label = [[self alloc] initWithFrame:CGRectZero];
    label.text = text;
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = textColor;
    label.textAlignment = textAliment;
    return label;
}


@end;


@implementation UIImageView (Create)

+ (instancetype)createImageWithImageName:(NSString *)imageName
                           contentMode:(UIViewContentMode) contentMode{
    
    UIImageView *imageView = [[self alloc] initWithFrame:CGRectZero];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = contentMode;
    return imageView;
}

@end
