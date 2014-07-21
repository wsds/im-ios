//
//  GroupData.h
//  MiniCom
//
//  Created by wlp on 14-6-17.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalData.h"

@interface GroupData : NSObject

@property(nonatomic, retain) NSString *gid;
@property(nonatomic, retain) NSString *gtype;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *description;
@property(nonatomic, retain) NSString *mainBusiness;
@property(nonatomic, retain) NSString *icon;
@property(nonatomic, retain) LocalData *location;
@property(nonatomic, retain) NSArray *members;

@end
