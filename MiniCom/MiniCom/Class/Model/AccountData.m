//
//  AccountData.m
//  MiniCom
//
//  Created by wlp on 14-6-12.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "AccountData.h"

@implementation AccountData

- (id)init
{
    self = [super init];
    if (self){
        self.ID = @"";
        self.byPhone = @"";
        self.friendStatus = @"";
        self.head = @"";
        self.mainBusiness = @"";
        self.nickName = @"";
        self.phone = @"";
        self.sex = @"";
        self.userBackground = @"";
        
        self.gid = @"";
        
        self.message = @"";
        self.rid = @"";
        self.uid = @"";

    }
    return  self;
}

@end
