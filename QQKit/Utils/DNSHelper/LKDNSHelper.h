//
//  LKDNSHelper.h
//  LKNovelty
//
//  Created by RoyLei on 16/12/1.
//  Copyright © 2016年 Laka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKDNSHelper : NSObject

/*!
 * 通过hostname获取ip列表 DNS解析地址
 */
+ (NSArray *)getDNSsWithDormain:(NSString *)hostName;

/**
 通过hostname获取ipv4 DNS解析地址
 
 @param hostName hostname
 @return ipv4
 */
+ (NSArray *)getIPV4DNSWithHostName:(NSString *)hostName;

/**
 通过hostname获取ipv6 DNS解析地址
 
 @param hostName hostname
 @return ipv6
 */
+ (NSArray *)getIPV6DNSWithHostName:(NSString *)hostName;


@end
