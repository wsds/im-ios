//
//  AngleTools.h
//  MiniCom
//
//  Created by wlp on 14-6-17.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalData.h"
#import "AccountData.h"

@interface AnalyTools : NSObject

+ (LocalData *)analyLocal:(NSDictionary *)dic;

+ (AccountData *)analyAccount:(NSDictionary *)dic;

@end
