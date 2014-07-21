//
//  SessionEvent.h
//  MiniCom
//
//  Created by wlp on 14-6-15.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GCDAsyncSocket;

@interface SessionEvent : NSObject
{
    BOOL _start;
    
    GCDAsyncSocket *asyncSocket;
}

+ (SessionEvent *)SharedInstance;

- (void)setSessionEventRequestStart:(BOOL)start;

@end
