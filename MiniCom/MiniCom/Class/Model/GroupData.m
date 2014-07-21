//
//  GroupData.m
//  MiniCom
//
//  Created by wlp on 14-6-17.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "GroupData.h"

@implementation GroupData

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.gid = @"";
        self.gtype = @"";
        self.name = @"";
        self.description = @"";
        self.mainBusiness = @"";
        self.icon = @"";
    }
    return self;
}

@end
