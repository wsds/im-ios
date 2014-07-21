//
//  SquareMessData.h
//  MiniCom
//
//  Created by wlp on 14-5-31.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SquareMessData : NSObject

@property(nonatomic, retain) NSString *gmid;
@property(nonatomic, retain) NSString *sendType;
@property(nonatomic, retain) NSString *messageType;
@property(nonatomic, retain) NSString *contentType;
@property(nonatomic, retain) NSString *cover;
@property(nonatomic, retain) NSString *phone;
@property(nonatomic, retain) NSString *nickName;
@property(nonatomic, retain) NSString *head;
@property(nonatomic, retain) NSString *gid;
@property(nonatomic, retain) NSString *time;

@property(nonatomic, retain) NSArray *praiseusers;

@property(nonatomic, retain) NSArray *content;


@end
