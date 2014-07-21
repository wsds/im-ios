//
//  NSString+Tools.m
//  MiniCom
//
//  Created by wlp on 14-5-18.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "NSString+Tools.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Tools)

- (BOOL)isUserName;
{
//    if ([self length] > 0) {
//        return YES;
//    }
//    return NO;
    
    if ([self length] == 11) {
        if ([[self substringToIndex:1] isEqualToString:@"1"]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isPassword
{
    NSString * PASSWORD = @"^[\@A-Za-z0-9\!\#\$\%\^\&\*\.\~]{6,18}$";
    NSPredicate *regextestpassword = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PASSWORD];
    if ([regextestpassword evaluateWithObject:self])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSString*)sha1Str
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    NSLog(@"output==%@", output);
    return output;
}

- (BOOL)isGifFileName
{
    if ([self length] > 4)
    {
        NSString *fileType = [self substringWithRange: NSMakeRange([self length] - 3, 3)];
        if ([fileType isEqualToString:@"gif"]) {
            NSString* dataFilePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[self lastPathComponent]];
            NSFileManager* fm=[NSFileManager defaultManager];
            return [fm fileExistsAtPath:dataFilePath];
        }
        else
        {
            return NO;
        }
    }
    return NO;
}

@end
