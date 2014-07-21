//
//  LocalData.m
//  MiniCom
//
//  Created by wlp on 14-6-17.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "LocalData.h"

@implementation LocalData

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.latitude = @"";
        self.longitude = @"";
        self.radius = @"";
    }
    return self;
}
@end
