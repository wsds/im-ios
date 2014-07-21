//
//  NSString+Tools.h
//  MiniCom
//
//  Created by wlp on 14-5-18.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tools)

- (BOOL)isUserName;

- (BOOL)isPassword;

- (BOOL)isGifFileName;

- (NSString*)sha1Str;

@end
