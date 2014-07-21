//
//  AccountData.h
//  MiniCom
//
//  Created by wlp on 14-6-12.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountData : NSObject

@property(nonatomic, retain) NSString *ID;

@property(nonatomic, retain) NSString *byPhone;
@property(nonatomic, retain) NSString *friendStatus;
@property(nonatomic, retain) NSString *head;
@property(nonatomic, retain) NSString *mainBusiness;
@property(nonatomic, retain) NSString *nickName;
@property(nonatomic, retain) NSString *phone;
@property(nonatomic, retain) NSString *sex;
@property(nonatomic, retain) NSString *userBackground;

@property(nonatomic, retain) NSString *gid;

//new friend
@property(nonatomic, retain) NSString *message;
@property(nonatomic, retain) NSString *rid;
@property(nonatomic, retain) NSString *uid;

@property(nonatomic, retain) NSString *alias;

@end
