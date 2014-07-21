//
//  AngleTools.m
//  MiniCom
//
//  Created by wlp on 14-6-17.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "AnalyTools.h"

@implementation AnalyTools

+ (LocalData *)analyLocal:(NSDictionary *)dic
{
    LocalData *data = [[LocalData alloc] init];
    data.longitude = [dic valueForKey:@"longitude"];
    data.latitude = [dic valueForKey:@"latitude"];
    return data;
}

+ (AccountData *)analyAccount:(NSDictionary *)valueDic
{
    AccountData *account = [[AccountData alloc] init];
    account.ID = [NSString stringWithFormat:@"%@", [valueDic valueForKey:@"ID"]];
    account.byPhone = [valueDic valueForKey:@"byPhone"];
    account.friendStatus = [valueDic valueForKey:@"friendStatus"];
    account.head = [valueDic valueForKey:@"head"];
    account.mainBusiness = [valueDic valueForKey:@"mainBusiness"];
    account.nickName = [valueDic valueForKey:@"nickName"];
    account.phone = [NSString stringWithFormat:@"%@", [valueDic valueForKey:@"phone"]];
    account.sex = [valueDic valueForKey:@"sex"];
    account.userBackground = [valueDic valueForKey:@"userBackground"];
    
    account.gid = [NSString stringWithFormat:@"%@",[valueDic valueForKey:@"gid"]];

    account.message = [valueDic valueForKey:@"message"];
    account.rid = [NSString stringWithFormat:@"%@", [valueDic valueForKey:@"rid"]];
    account.uid = [NSString stringWithFormat:@"%@", [valueDic valueForKey:@"uid"]];

    return account;
}

@end
