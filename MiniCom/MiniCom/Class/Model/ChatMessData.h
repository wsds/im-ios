//
//  ChatMessData.h
//  MiniCom
//
//  Created by wlp on 14-6-15.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatMessData : NSObject

@property(nonatomic, retain) NSString *contentType; //text||image||voice
@property(nonatomic, retain) NSString *sendType;
@property(nonatomic, retain) NSString *phone;
@property(nonatomic, retain) NSString *phoneToOrFrom;
@property(nonatomic, retain) NSString *content;
@property(nonatomic, retain) NSString *time;
@property(nonatomic, assign) int isRead;
@property(nonatomic, assign) int isSend;
@property(nonatomic, retain) NSString *gid;

@end
