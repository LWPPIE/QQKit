//
//  LKLogger.m
//  Pods
//
//  Created by RoyLei on 16/11/15.
//
//

#import "LKLogger.h"
#import "NSDate+Utilities.h"
#import <mach/mach_time.h>

NSString *const LKLogFileName = @"LKLogFile.txt";

static inline double MachTimeToSecs(uint64_t time)
{
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);
    return (double)time * (double)timebase.numer /  (double)timebase.denom / 1e9;
}

@interface LKLogger()
{
    uint64_t mBegin;
    uint64_t mEnd;
    NSString *_logFilePath;
}
@end

@implementation LKLogger

- (instancetype)init
{
    self = [super init];
    if (self) {
        _type = LKLoggerTypeNormal;
    }
    return self;
}

- (void)logFormatString:(NSString *)string showTimeInterval:(BOOL)shouldShow
{
    NSString *logStr = string;
    if (shouldShow) {
        mEnd = mach_absolute_time();
        logStr = [NSString stringWithFormat:@"%@ 总耗时: %@(s)", string, @(MachTimeToSecs(mEnd - mBegin))];
    }
    
    switch (_type) {
        case LKLoggerTypeNormal:
        {
            NSLog(@"[##] %@", logStr);
            break;
        }
        case LKLoggerTypeHttp:
        {
            NSLog(@"[Http] %@", logStr);
            break;
        }
        case LKLoggerTypeSocketIO:
        {
            NSLog(@"[SocketIO] %@", logStr);
            break;
        }
        default:
        {
            NSLog(@"[Other] %@", logStr);
            break;
        }
    }
}

#pragma mark - Public Method

- (void)startLog
{
    mBegin = mach_absolute_time();
}

- (void)startLog:(NSString *)fmt, ...
{
#ifdef DEBUG
    mBegin = mach_absolute_time();
    
    va_list args;
    va_start(args, fmt);
    va_end(args);
    
    NSString *string = [[NSString alloc] initWithFormat:fmt arguments:args];
    [self logFormatString:string showTimeInterval:NO];
#endif
}

- (void)log:(NSString *)fmt, ...
{
#ifdef DEBUG
    va_list args;
    va_start(args, fmt);
    va_end(args);
    
    NSString *string = [[NSString alloc] initWithFormat:fmt arguments:args];
    [self logFormatString:string showTimeInterval:NO];

#endif
}

- (void)logTime:(NSString *)fmt, ...
{
#ifdef DEBUG
    mEnd = mach_absolute_time();
    
    va_list args;
    va_start(args, fmt);
    va_end(args);
    
    NSString *string = [[NSString alloc] initWithFormat:fmt arguments:args];
    [self logFormatString:string showTimeInterval:YES];
#endif
}

- (void)logToFile:(NSString *)format, ...
{
#ifdef DEBUG
    va_list args;
    va_start(args, format);
    NSString *logStr = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    
    logStr = [[[NSDate date] stringWithFormat:@"[yyyy-MM-dd HH:mm:ss]:"] stringByAppendingString:logStr];
    
//    NSLog(@"%@",  logStr);
    
    if(!_logFilePath){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [[paths objectAtIndex:0] copy];
        _logFilePath = [documentsDirectory stringByAppendingPathComponent:LKLogFileName];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:_logFilePath]) {
        [logStr writeToFile:_logFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }else {
        NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:_logFilePath];
        [fileHandler seekToEndOfFile];
        [fileHandler writeData:[logStr dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandler closeFile];
    }
    
#endif
}

@end
