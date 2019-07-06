//
//  NSString+LKTransform.h
//  Pods
//
//  Created by RoyLei on 16/11/16.
//
//

#import <Foundation/Foundation.h>

@interface NSString (LKTransform)

/**
 *  数字的转换 例如 ： 100000000 -> 1亿 ,10000 -> 1万，1000 -> 1千
 *
 *  @param number 字符数字
 *
 *  @return 显示的数字
 */
+ (NSString *)lk_stringToTransformCount:(NSString *)countString;

/**
 *  数字的转换 例如 ： 10000 -> 1万
 *
 *  @param number 字符数字
 *
 *  @return 显示的数字
 */
+ (NSString *)lk_stringToWanTransformCount:(NSString *)countString;

/**
 显示时间格式：XX分钟、小时、昨天、N天前

 @param timeInterval 要转换的时间timeInterval
 @return 要显示的时间字符串
 */
+ (NSString *)lk_timeAgoStyleStringWithTimeInterval:(NSTimeInterval)timeInterval;

/**
 人性化，时间显示格式00:00, 星期X, xxxx年xx月xx日，
 
 @param timeInterval 要转换的时间timeInterval
 @return 要显示的时间字符串
 */
+ (NSString *)lk_getTimeStrStyleWithTimeInterval:(NSTimeInterval)timeInterval;

/**
 人性化，时间显示格式00:00, 星期X, xxxx年xx月xx日，

 @param date 要转换的时间NSDate
 @return 要显示的时间字符串
 */
+ (NSString *)lk_getTimeStrStyleWithDate:(NSDate *)date;


/**
 视频文件转换 字节 转成 KB MB GB

 @param filesize 视频文件大小
 @return         转换成的大小
 */
+ (NSString *)videoSize:(uint64_t)filesize;

@end
