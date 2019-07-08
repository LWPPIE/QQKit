//
//  NSData+AES.m
//  Live
//
//  Created by Heller on 16/3/14.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import "NSData+AES.h"

#import <CommonCrypto/CommonCryptor.h>

//#import "aes.h"

@implementation NSData (AES)

- (NSData *)AES128EncryptWithKey:(NSString *)key//加密
{
    return [self AESOperation:kCCEncrypt key:key iv:key aesType:0];
}

#define TLV_AES_SIZE 16
- (NSData *)AES128DecryptWithKey:(NSString *)key//解密
{
//    AES_KEY aes_key;
//    if(AES_set_decrypt_key((const unsigned char *)[key UTF8String], TLV_AES_SIZE * 8, &aes_key) < 0)
//    {
//        return nil;
//    }
// 
//    void *buffer = malloc(self.length);
//    const unsigned char *bytes = self.bytes;
//    for (int i = 0; i < self.length; i += TLV_AES_SIZE)
//    {
//        AES_decrypt(bytes + i, buffer + i, &aes_key);
//    }
//    
//    NSData *data = [NSData dataWithBytesNoCopy:buffer length:self.length];
//    return data;
    
    return [self AESOperation:kCCDecrypt key:key iv:key aesType:0];
}

- (NSData *)AESOperation:(CCOperation)operation key:(NSString *)key iv:(NSString *)iv aesType:(int)aesType
{
    NSUInteger aesKeySizeType;
    NSUInteger aesBlockSizeType = kCCBlockSizeAES128;
    CCAlgorithm aesAlgorithmType = kCCAlgorithmAES128;
    switch (aesType)
    {
        case 0://kAesType128:
            aesKeySizeType = kCCKeySizeAES256;
            break;
        case 1://kAesType192:
            aesKeySizeType = kCCKeySizeAES192;
            break;
        case 2://kAesType256:
            aesKeySizeType = kCCKeySizeAES256;
            break;
        default:
            aesKeySizeType = kCCKeySizeAES256;
            break;
    }
    
    char keyPtr[aesKeySizeType + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[aesBlockSizeType + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + aesBlockSizeType;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          aesAlgorithmType,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          aesBlockSizeType,
                                          ivPtr,
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    NSData *data = nil;
    if (cryptStatus == kCCSuccess) {
        data = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
    }
    return data;
}

@end
