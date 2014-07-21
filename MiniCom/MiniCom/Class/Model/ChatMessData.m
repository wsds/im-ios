//
//  ChatMessData.m
//  MiniCom
//
//  Created by wlp on 14-6-15.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "ChatMessData.h"

@implementation ChatMessData

- (id)init
{
    self = [super init];
    if (self){
        self.contentType = @"";
        self.sendType = @"";
        self.phone = @"";
        self.phoneToOrFrom = @"";
        self.content = @"";
        self.time = @"";
        
        self.gid = @"";
    }
    return  self;
}

@end
