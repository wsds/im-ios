//
//  RequestResult.h
//  MiniCom
//
//  Created by wlp on 14-5-19.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestResult : NSObject

@property (strong, nonatomic) id myData;
@property (nonatomic) BOOL isSuccess;
@property (nonatomic) NSInteger errorCode,tag;
@property (strong, nonatomic) NSString *message;
@end
