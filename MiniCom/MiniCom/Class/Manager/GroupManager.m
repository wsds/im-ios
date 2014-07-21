//
//  GroupManager.m
//  MiniCom
//
//  Created by wlp on 14-7-6.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "GroupManager.h"
#import "GroupData.h"

@implementation GroupManager

static GroupManager *object = nil;

+ (GroupManager *)SharedInstance
{
    @synchronized(self)
    {
        if (object == nil)
        {
            object = [[GroupManager alloc] init];
        }
    }
    return object;
}

- (id)init
{
    self = [super init];
    if (self){
        _groupAry = [[NSArray alloc] init];
    }
    return  self;
}

- (GroupData *)getGroupDataById:(NSString *)gid
{
    for (GroupData *gData in self.groupAry) {
        if ([gData.gid isEqualToString:gid]) {
            return gData;
        }
    }
    return nil;
}

@end
