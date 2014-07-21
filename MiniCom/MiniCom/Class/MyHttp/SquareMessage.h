//
//  SquareMessage.h
//  MiniCom
//
//  Created by wlp on 14-6-20.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GCDAsyncSocket;

@interface SquareMessage : NSObject
{
    BOOL _start;
    
    GCDAsyncSocket *asyncSocket;
}

+ (SquareMessage *)SharedInstance;

- (void)setSquareMessageRequestStart:(BOOL)start;

- (void)setSquareDataWithMessAry:(NSArray *)messageAry;

@end
