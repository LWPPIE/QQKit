//
//  LKLogger.h
//  Pods
//
//  Created by RoyLei on 16/11/15.
//
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define LKLOG 1
#else
#define LKLOG 0
#endif

#if LKLOG
#define NSLog(msg, args...) NSLog(msg, ##args)
#else
#define NSLog(msg, args...)
#endif

#ifdef DEBUG
#define LKLOG_SOCKETIO 1
#endif

typedef NS_ENUM(NSInteger, LKLoggerType)
{
    LKLoggerTypeNormal = 0, /**< 普通日志 */
    LKLoggerTypeHttp,       /**< Http 请求日志 */
    LKLoggerTypeSocketIO,   /**< SocketIO 请求日志 */
};

@interface LKLogger : NSObject

@property (nonatomic, assign) LKLoggerType type; /**< 日志类型 */

/**
 开始计时
 */
- (void)startLog;

/**
 开始计时并打印日志

 @param fmt 格式化日志
 */
- (void)startLog:(NSString *)fmt, ...;

/**
 结束计时并打印日志
 
 @param fmt 格式化日志
 */
- (void)log:(NSString *)fmt, ...;

/**
 结束计时并打印带有时间间隔的日志
 
 @param fmt 格式化日志
 */
- (void)logTime:(NSString *)fmt, ...;

/**
 写日志到Document 日志 LKLogFile.txt
 
 @param fmt 格式化日志
 */
- (void)logToFile:(NSString *)format, ...;

@end
