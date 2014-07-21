//
//  GroupManager.h
//  MiniCom
//
//  Created by wlp on 14-7-6.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GroupData;

@interface GroupManager : NSObject

@property(nonatomic, retain) NSArray *groupAry;

+ (GroupManager *)SharedInstance;

- (GroupData *)getGroupDataById:(NSString *)gid;

@end
