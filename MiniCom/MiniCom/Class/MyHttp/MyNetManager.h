//
//  MyNetManager.h
//  MiniCom
//
//  Created by wlp on 14-6-26.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Reachability;

enum
{
    ENUM_NetRequest_UploadLocal,
    ENUM_NetRequest_UploadLocalGroup,
    ENUM_NetRequest_UploadResouceCheck,
    ENUM_NetRequest_UploadResouce,
    ENUM_NetRequest_DownloadResouce,
};

@interface MyNetManager : NSObject
{
    Reachability *hostReach;
}

@property(nonatomic, assign) BOOL isNetWork;

+ (MyNetManager *)SharedInstance;

//上传位置信息
- (void)reqestUploadLocationLat:(NSString *)lat longitude:(NSString *)longitude;

- (void)reqestUploadResouceData:(NSData *)data name:(NSString *)fileName;


@end
