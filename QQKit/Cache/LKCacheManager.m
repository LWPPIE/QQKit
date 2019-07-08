//
//  LKCacheManager.m
//  LKNovelty
//
//  Created by RoyLei on 16/11/9.
//  Copyright © 2016年 Laka. All rights reserved.
//

#import "LKCacheManager.h"

NSString *const LKSearchHistoryRecordKey = @"KEY_OF_LKSearchHistory";
NSString *const LKPlayerShowGuideViewKey = @"KEY_OF_LKPlayerShowGuideViewKey";

NSString *const LKCacheDocumentName = @"com.laka.caches";
NSString *const LKCacheManagerVideoDIRName = @"video";
NSString *const LKCacheManagerUserDataDIRName = @"user";
NSString *const LKCacheManagerCommentDIRName = @"comment";
NSString *const LKCacheManagerCleanDIRName = @"canClean";

NSInteger const LKPlayerTimeRecordCount = 3; ///< 记录上一次视频播放时长数量
NSString *const LKPlayerTimeRecordKey = @"KeyOfLKPlayerTimeRecordKey"; ///< 记录上一次视频播放时长键

static inline NSString *LKCacheDefaultPath()
{
    NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [cacheFolder stringByAppendingPathComponent:LKCacheDocumentName];
    return path;
}

static inline NSString *LKLibraryDefaultPath()
{
    NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [cacheFolder stringByAppendingPathComponent:LKCacheDocumentName];
    return path;
}

static inline LKCacheFactory *LKCacheFactoryInstance(){
    return [LKCacheFactory sharedInstance];
}

#pragma mark - Class LKCacheFactory

@interface LKCacheFactory ()

@property (strong, nonatomic) NSMutableDictionary <NSNumber *, LKCacheManager *> *cacheManagers;

@end

@implementation LKCacheFactory

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _cacheManagers = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (LKCacheManager *)cacheManger:(LKCacheManagerType)type
{
    LKCacheManager *cacheManger = LKCacheFactoryInstance().cacheManagers[@(type)];
    switch (type) {
        case LKCacheManagerTypeCanClean:
        {
            if (!cacheManger) {
                cacheManger = [[LKCacheManager alloc] initWithPath:[LKCacheDefaultPath() stringByAppendingPathComponent:LKCacheManagerCleanDIRName]];
                [LKCacheFactoryInstance().cacheManagers setObject:cacheManger forKey:@(type)];
            }
            break;
        }
        case LKCacheManagerTypeVideo:
        {
            if (!cacheManger) {
                cacheManger = [[LKCacheManager alloc] initWithPath:[LKCacheDefaultPath() stringByAppendingPathComponent:LKCacheManagerVideoDIRName]];
                [LKCacheFactoryInstance().cacheManagers setObject:cacheManger forKey:@(type)];
            }
            break;
        }
        case LKCacheManagerTypeUserData:
        {
            if (!cacheManger) {
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                // 移动旧的缓存目录到Library 目录下，做为长期存储，避免Cahce目录被系统清理
                NSString *oldDir = [LKCacheDefaultPath() stringByAppendingPathComponent:LKCacheManagerUserDataDIRName];
                NSString *newDir = [LKCacheDefaultPath() stringByAppendingPathComponent:LKCacheManagerUserDataDIRName];

                if ([fileManager fileExistsAtPath:oldDir]) {
                    [fileManager moveItemAtPath:oldDir toPath:newDir error:nil];
                }
                
                cacheManger = [[LKCacheManager alloc] initWithPath:[LKLibraryDefaultPath() stringByAppendingPathComponent:LKCacheManagerUserDataDIRName]];
                [LKCacheFactoryInstance().cacheManagers setObject:cacheManger forKey:@(type)];
            }
            break;
        }case LKCacheManagerTypeComment:
        {
            if (!cacheManger) {
                
                // 移动旧的缓存目录到Library 目录下，做为长期存储，避免Cahce目录被系统清理
                NSFileManager *fileManager = [NSFileManager defaultManager];

                NSString *oldDir = [LKCacheDefaultPath() stringByAppendingPathComponent:LKCacheManagerCommentDIRName];
                NSString *newDir = [LKCacheDefaultPath() stringByAppendingPathComponent:LKCacheManagerCommentDIRName];
                
                if ([fileManager fileExistsAtPath:oldDir]) {
                    [fileManager moveItemAtPath:oldDir toPath:newDir error:nil];
                }
                
                cacheManger = [[LKCacheManager alloc] initWithPath:[LKLibraryDefaultPath() stringByAppendingPathComponent:LKCacheManagerCommentDIRName]];
                [LKCacheFactoryInstance().cacheManagers setObject:cacheManger forKey:@(type)];
            }
            break;
        }
        default:
            break;
    }
    
    return cacheManger;
}

@end

#pragma mark - Class LKCacheManager

@interface LKCacheManager()

@property (strong, nonatomic) NSMutableDictionary *placeHolderCahce;
@property (strong, nonatomic) NSMutableArray <NSMutableDictionary *> *playerTimeArray;
@end

@implementation LKCacheManager

+ (NSString *)cacheTmpVideosPath
{
    NSString *tmpVideoDir = [LKLibraryDefaultPath() stringByAppendingPathComponent:@"tmpVideos"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:tmpVideoDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:tmpVideoDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return tmpVideoDir;
}

+ (NSString *)cacheConvertVideosPath
{
    NSString *tmpVideoDir = [LKLibraryDefaultPath() stringByAppendingPathComponent:@"convertVideos"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:tmpVideoDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:tmpVideoDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return tmpVideoDir;
}

- (instancetype)initWithPath:(NSString *)path
{
    self = [super initWithPath:path];
    if (self) {
        _placeHolderCahce = [NSMutableDictionary dictionary];
        _playerTimeArray = [NSMutableArray array];
    }
    return self;
}

- (UIImage *)extendPlaceHolder:(NSString *)imageName
                    extendSize:(CGSize)size
                   extendColor:(UIColor *)color
{
    UIImage *placeHolder = [UIImage imageNamed:imageName];
    
    NSString *recordKey = [NSString stringWithFormat:@"%@_%@_%@", imageName, NSStringFromCGSize(size), [color hexString]];
    UIImage *retImage = [self.placeHolderCahce objectForKey:recordKey];
    if (retImage) {
        return retImage;
    }
    
    retImage = [LKCacheManager createBackgroundPlaceholder:placeHolder
                                             imageWithSize:size
                                               extendColor:color];
    
    if (retImage) {
        [self.placeHolderCahce setObject:retImage forKey:recordKey];
    }
    
    return retImage;
}

+ (UIImage *)createBackgroundPlaceholder:(UIImage *)placeHolder
                           imageWithSize:(CGSize)size
                             extendColor:(UIColor *)color
{

    CGSize originSize = placeHolder.size;

    CGFloat originX = (size.width - originSize.width)/2;
    CGFloat originY = (size.height - originSize.height)/2;
    
    CGRect retRect = CGRectMake(0, 0, size.width, size.height);
    CGRect originRect = CGRectMake(originX, originY, originSize.width, originSize.height);
    
    UIImage *bgImage = [UIImage imageWithColor:color size:size];
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    [bgImage drawInRect:retRect];
    [placeHolder drawInRect:originRect];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

+ (NSTimeInterval)videoLastPlayTime:(NSString *)videoUrl
{
    if(!videoUrl || videoUrl.length == 0) {
        return 0;
    }
    
    LKCacheManager *dataCache = [LKCacheFactory cacheManger:LKCacheManagerTypeUserData];
    
    NSString *recordKey = [videoUrl md5String];

    __block NSTimeInterval lastPlayTime = 0;
    [dataCache.playerTimeArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        @autoreleasepool {
            NSNumber *value = obj[recordKey];

            if (value) {
                lastPlayTime = [value doubleValue];
                *stop = YES;
            }
        }
        
    }];
    
    return lastPlayTime;
}

+ (void)setVideoLastPlayTime:(NSTimeInterval)lastPlayTime videoUrl:(NSString *)videoUrl
{
    if(!videoUrl || videoUrl.length == 0) {
        return;
    }
    
    LKCacheManager *dataCache = [LKCacheFactory cacheManger:LKCacheManagerTypeUserData];

    NSString *recordKey = [videoUrl md5String];
    __block NSMutableDictionary *recordDict = nil;
    
    // 匹配之前是否有存储
    [dataCache.playerTimeArray enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        @autoreleasepool {
            if ([obj.allKeys containsObject:recordKey]) {
                recordDict = obj;
                *stop = YES;
            }
        }
        
    }];
    
    if (!recordDict) {
        recordDict = [NSMutableDictionary dictionary];
        [dataCache.playerTimeArray addObject:recordDict];
    }
    
    [recordDict setObject:@(lastPlayTime) forKey:recordKey];
    
    if (dataCache.playerTimeArray.count > LKPlayerTimeRecordCount) {
        [dataCache.playerTimeArray removeFirstObject];
    }
}

@end
