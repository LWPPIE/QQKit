//
//  NSString+LKTransform.m
//  Pods
//
//  Created by RoyLei on 16/11/16.
//
//

#import "NSString+LKTransform.h"
#import "NSDate+Utilities.h"

const int MB = 1024 * 1024;        //定义MB的计算常量

@implementation NSString (LKTransform)

+ (NSString *)lk_stringToTransformCount:(NSString *)countString;
{
    NSInteger num = [countString integerValue];
    NSString *result = countString;
    
    if(num >= 100000000) {
        result = [NSString stringWithFormat:@"%.1f亿", num / 100000000.0];
    }
    else if(num >= 10000){
        result = [NSString stringWithFormat:@"%.1f万", num / 10000.0];
    }
    else if (num >= 1000) {
        result = [NSString stringWithFormat:@"%.1f千", num / 1000.0];
    }
    return result;
}

+ (NSString *)lk_stringToWanTransformCount:(NSString *)countString;
{
    NSInteger num = [countString integerValue];
    NSString *result = countString;
    
    if(num >= 10000){
        result = [NSString stringWithFormat:@"%.1f万", num / 10000.0];
    }
    
    return result;
}

+ (NSString *)lk_timeAgoStyleStringWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSDate * date = [NSDate dateFromTimeInterVal:timeInterval];
    return [date stringTimeAgo:[NSDate date]];
}

+ (NSString *)lk_getTimeStrStyleWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [NSString lk_getTimeStrStyleWithDate:date];
}

+ (NSString *)lk_getTimeStrStyleWithDate:(NSDate *)date
{
    if(!date){
        return @"";
    }
    
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay|NSCalendarUnitYear |NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    
    int year=(int)[component year];
    int month=(int)[component month];
    int day=(int)[component day];
    int hour=(int)[component hour];
    int minute=(int)[component minute];
    int week= (int)[component weekOfMonth];
    int weekday=(int)[component weekday];
    
    NSDate * today=[NSDate date];
    component=[calendar components:unitFlags fromDate:today];
    
    int t_year=(int)[component year];
    int t_month=(int)[component month];
    int t_day=(int)[component day];
    int t_week=(int)[component weekOfMonth];
    
    NSString*string=nil;
    if(year==t_year&&month==t_month&&day==t_day)
    {
        if(hour<6&&hour>=0)
            string=[NSString stringWithFormat:@"%d:%02d",hour,minute];
        else if(hour>=6&&hour<12)
            string=[NSString stringWithFormat:@"%d:%02d",hour,minute];
        else if(hour>=12&&hour<18)
            string=[NSString stringWithFormat:@"%d:%02d",hour,minute];
        else
            string=[NSString stringWithFormat:@"%d:%02d",hour,minute];
    }
    else if((t_day -day) ==1)
    {
        if(hour<6&&hour>=0)
            string= @"昨天";
        //[NSString stringWithFormat:@"昨天"];
        //,hour,minute];
        else if(hour>=6&&hour<12)
            string= @"昨天";
        //[NSString stringWithFormat:@"昨天 %d:%02d",hour,minute];
        else if(hour>=12&&hour<18)
            string= @"昨天";
        //[NSString stringWithFormat:@"昨天 %d:%02d",hour,minute];
        else
            string= @"昨天";
        //[NSString stringWithFormat:@"昨天 %d:%02d",hour,minute];
        
    }
    else if(year==t_year&&week==t_week)
    {
        NSString * daystr=nil;
        switch (weekday) {
            case 1:
                daystr=@"日";
                break;
            case 2:
                daystr=@"一";
                break;
            case 3:
                daystr=@"二";
                break;
            case 4:
                daystr=@"三";
                break;
            case 5:
                daystr=@"四";
                break;
            case 6:
                daystr=@"五";
                break;
            case 7:
                daystr=@"六";
                break;
            default:
                break;
        }
        string=[NSString stringWithFormat:@"星期%@ ",daystr];
        //%02d",daystr,hour,minute];
    }
    else if(year==t_year)
        string=[NSString stringWithFormat:@"%d月%d日",month,day];
    else
        string=[NSString stringWithFormat:@"%d年%d月%d日",year,month,day];
    
    return string;
}

+ (NSString *)videoSize:(uint64_t)filesize
{
    float f = (float) filesize / MB;
    if (f > 100) {
        return [NSString stringWithFormat:@"%.0f M", f];
    }else{
        return [NSString stringWithFormat:@"%.1f M", f];
    }
}

@end
