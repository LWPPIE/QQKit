//
//  FTCoreTextView+StyleConfigure.m
//  ViewTest
//
//  Created by RoyLei on 14-6-30.
//  Copyright (c) 2014年 RoyLei. All rights reserved.
//

#import "FTCoreTextViewStyleDefine.h"
#import "FTCoreTextView.h"
#import <YYKit/UIColor+YYAdd.h>

#define buttonBlueColor         [UIColor colorWithRed:0.000 green:0.478 blue:1.000 alpha:1.000]
#define buttonGreenColor        [UIColor colorWithRed:0.424 green:0.667 blue:0.000 alpha:1.000]
#define buttonOrangeColor       [UIColor colorWithRed:1.000 green:0.471 blue:0.000 alpha:1.000]
#define buttonRedColor          [UIColor colorWithRed:0.682 green:0.086 blue:0.086 alpha:1.000]
#define buttonGrayColor         [UIColor colorWithWhite:0.600 alpha:1.000]


FTCoreTextStyle *defaultStyle(){
    FTCoreTextStyle *defaultStyle = [FTCoreTextStyle new];
    defaultStyle.name = FTCoreTextTagDefault;
    defaultStyle.textAlignment = FTCoreTextAlignementCenter;
    defaultStyle.font = [UIFont systemFontOfSize:kTRLAlertViewBasicTextSize];
    defaultStyle.color = [UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f];
    return defaultStyle;
}

FTCoreTextStyle *blueColorStyle(){
    FTCoreTextStyle *blueColoreStyle = defaultStyle();
    [blueColoreStyle setName:@"blued"];
    [blueColoreStyle setColor:UIColorHex(0x007aff)];
    return blueColoreStyle;
}

NSArray *createCoreTextNormalStyle()
{
    NSMutableArray *result = [NSMutableArray array];
    
    //  Define styles
	FTCoreTextStyle *defaultStyle = [FTCoreTextStyle new];
    defaultStyle.name = FTCoreTextTagDefault;
    defaultStyle.textAlignment = FTCoreTextAlignementCenter;
    defaultStyle.font = [UIFont systemFontOfSize:kTRLAlertViewBasicTextSize];
    defaultStyle.color = UIColorHex(0x0D0D0D);
    
    FTCoreTextStyle *tStyle = [defaultStyle copy];
    tStyle.name = @"title";
    tStyle.textAlignment = FTCoreTextAlignementCenter;
    
    FTCoreTextStyle *h1Style = [defaultStyle copy];
    h1Style.name = @"h1";
    h1Style.font = [UIFont systemFontOfSize:15.f];
    h1Style.textAlignment = FTCoreTextAlignementLeft;
    
    FTCoreTextStyle *h2Style = [h1Style copy];
    h2Style.name = @"h2";
    h2Style.font = [UIFont systemFontOfSize:13.f];
    h2Style.color = buttonBlueColor;
    
    FTCoreTextStyle *h3Style = [defaultStyle copy];
    h3Style.name = @"h3";
    h3Style.font = [UIFont systemFontOfSize:15.f];
    h3Style.textAlignment = FTCoreTextAlignementCenter;
    
    FTCoreTextStyle *h4Style = [defaultStyle copy];
    h4Style.name = @"h4";
    h4Style.font = [UIFont systemFontOfSize:13.f];
    h4Style.color = buttonGreenColor;
    h4Style.textAlignment = FTCoreTextAlignementCenter;
    
    FTCoreTextStyle *pStyle = [defaultStyle copy];
    pStyle.name = @"p";
    
    //  HTML link anchor "a"
    //  We first get default style for "_link" tag, rename it to "a"
    //  and then replace the default with new tag
    //  Mind you still need to use "_link"-like format
    //  <a>http://url.com|Dislayed text</a> format, not the html "<a href..." format
    FTCoreTextStyle *aStyle = [FTCoreTextStyle styleWithName:FTCoreTextTagLink];
    aStyle.name = @"a";
    aStyle.underlined = YES;
    aStyle.color = [UIColor redColor];
	
    FTCoreTextStyle *boldStyle = [defaultStyle copy];
	boldStyle.name = @"bold";
    boldStyle.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:16.f];
    
    FTCoreTextStyle *coloredStyle = [defaultStyle copy];
    [coloredStyle setName:@"colored"];
    [coloredStyle setColor:[UIColor redColor]];
    
    FTCoreTextStyle *blueColoreStyle = [defaultStyle copy];
    [blueColoreStyle setName:@"blued"];
    [blueColoreStyle setColor:UIColorHex(0x007aff)];
    
    FTCoreTextStyle *redColoreStyle = [defaultStyle copy];
    [redColoreStyle setName:@"red"];
    [redColoreStyle setColor:UIColorHex(0xFC1255)];
    redColoreStyle.font = [UIFont systemFontOfSize:16];

    FTCoreTextStyle *blueAndBoldColoreStyle = [defaultStyle copy];
    [blueAndBoldColoreStyle setName:@"b_blued"];
    [blueAndBoldColoreStyle setColor:UIColorHex(0x007aff)];
    blueAndBoldColoreStyle.font = [UIFont boldSystemFontOfSize:16];

    [result addObjectsFromArray:@[defaultStyle, h1Style, h2Style, h3Style, h4Style, pStyle, aStyle, boldStyle, coloredStyle,blueColoreStyle, redColoreStyle, blueAndBoldColoreStyle]];
    
    return  result;
}

NSArray *createCoreTextHighlightStyle()
{
    NSMutableArray *result = [NSMutableArray array];
    
    //  Define styles
	FTCoreTextStyle *defaultStyle = [FTCoreTextStyle new];
    defaultStyle.name = FTCoreTextTagDefault;
    defaultStyle.textAlignment = FTCoreTextAlignementCenter;
    defaultStyle.font = [UIFont systemFontOfSize:kTRLAlertViewBasicTextSize];
    defaultStyle.color = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.5f];

    
    FTCoreTextStyle *tStyle = [defaultStyle copy];
    tStyle.name = @"title";
    
    FTCoreTextStyle *h1Style = [defaultStyle copy];
    h1Style.name = @"h1";
    h1Style.font = [UIFont systemFontOfSize:15.f];
    h1Style.textAlignment = FTCoreTextAlignementLeft;
    
    FTCoreTextStyle *h2Style = [h1Style copy];
    h2Style.name = @"h2";
    h2Style.font = [UIFont systemFontOfSize:13.f];
    h2Style.color = buttonGrayColor;
    
    FTCoreTextStyle *h3Style = [defaultStyle copy];
    h3Style.name = @"h3";
    h3Style.font = [UIFont systemFontOfSize:15.f];
    h3Style.textAlignment = FTCoreTextAlignementCenter;
    
    FTCoreTextStyle *h4Style = [defaultStyle copy];
    h4Style.name = @"h4";
    h4Style.font = [UIFont systemFontOfSize:13.f];
    h4Style.color = buttonGrayColor;
    h4Style.textAlignment = FTCoreTextAlignementCenter;
    
    FTCoreTextStyle *pStyle = [defaultStyle copy];
    pStyle.name = @"p";
    
    //  HTML link anchor "a"
    //  We first get default style for "_link" tag, rename it to "a"
    //  and then replace the default with new tag
    //  Mind you still need to use "_link"-like format
    //  <a>http://url.com|Dislayed text</a> format, not the html "<a href..." format
    FTCoreTextStyle *aStyle = [FTCoreTextStyle styleWithName:FTCoreTextTagLink];
    aStyle.name = @"a";
    aStyle.underlined = YES;
    aStyle.color = [UIColor blueColor];
	
    FTCoreTextStyle *boldStyle = [defaultStyle copy];
	boldStyle.name = @"bold";
    boldStyle.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:16.f];
    
    FTCoreTextStyle *coloredStyle = [defaultStyle copy];
    [coloredStyle setName:@"colored"];
    [coloredStyle setColor:[UIColor redColor]];
    
    [result addObjectsFromArray:@[defaultStyle, h1Style, h2Style, h3Style, h4Style, pStyle, aStyle, boldStyle, coloredStyle]];
    
    return  result;
}
