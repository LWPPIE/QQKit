//
//  NSData+AES.h
//  Live
//
//  Created by Heller on 16/3/14.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define AES_KEY @"ffffffffffffffff" //可以自行定义16位

@interface NSData (AES)

//- (NSData *)AES128EncryptWithKeyData:(NSData *)key;//加密
//- (NSData *)AES128DecryptWithKeyData:(NSData *)key;//解密
- (NSData *)AES128EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES128DecryptWithKey:(NSString *)key;   //解密

@end
