//
//  RSA1.h
//  RSA1
//
//  Created by wlp on 14-8-10.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSADecode : NSObject

+ (NSString *)decryptHexStr:(NSString *)hexString keyStr:(NSString *)pbkey;

@end
