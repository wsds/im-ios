//
//  MyNetManager.m
//  MiniCom
//
//  Created by wlp on 14-6-26.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "MyNetManager.h"
#import "MyHttpRequest.h"
#import "AccountManager.h"
#import "AccountData.h"
#import "GTMBase64.h"
#import "NSString+Tools.h"
#import "ASIHTTPRequest.h"


#import "Reachability.h"

@implementation MyNetManager

static MyNetManager *object = nil;

+ (MyNetManager *)SharedInstance
{
    @synchronized(self)
    {
        if (object == nil)
        {
            object = [[MyNetManager alloc] init];
        }
    }
    return object;
}

- (id)init
{
    self = [super init];
    if (self){
        self.isNetWork = YES;

        hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        [hostReach startNotifier];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];

    }
    return self;
}

- (void)reachabilityChanged:(NSNotification *)note {
    self.isNetWork = YES;

    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            // 没有网络连接
            NSLog(@"NotReachable");
            self.isNetWork = NO;

            break;
        case ReachableViaWWAN:
            // 使用3G网络
            NSLog(@"ReachableViaWWAN");
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            NSLog(@"ReachableViaWiFi");
            break;
    }
    
    if (self.isNetWork) {
        //[[NSNotificationCenter defaultCenter] postNotificationName:NetChangeNotification object:nil];
    }
}

- (void)reqestUploadLocationLat:(NSString *)lat longitude:(NSString *)longitude;
{
    NSDictionary *localDic = @{@"longitude":lat,
                               @"latitude":longitude};
    NSDictionary *accountDic = @{@"mainBusiness":[AccountManager SharedInstance].userInfoData.mainBusiness,
                               @"head":[AccountManager SharedInstance].userInfoData.head,
                                 @"nickName":[AccountManager SharedInstance].userInfoData.nickName};
    NSDictionary *dic_params = @{@"location":[localDic JSONString],
                                 @"account":[accountDic JSONString]};
    
    //上传位置
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_lbs_updatelocation
                                                    params:dic_params
                                                       tag:ENUM_NetRequest_UploadLocal
                                                   needHud:NO
                                                   hudText:@""
                                                 needLogin:YES];
    MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
    [myHttp startRequest:params
               hudOnView:nil
                delegate:self];
    
//    NSDictionary *groupDic = @{@"gid":@"98",
//                                 @"name":@"aaa",
//                                 @"description":@"aaa"};
//    NSDictionary *dic_params2 = @{@"location":[localDic JSONString],
//                                  @"group":[groupDic JSONString]};
//    //上传位置 标记群组
//    Params4Http *params2 = [[Params4Http alloc] initWithUrl:URL_lbs_setgrouplocation
//                                                    params:dic_params2
//                                                       tag:ENUM_NetRequest_UploadLocalGroup
//                                                   needHud:NO
//                                                   hudText:@""
//                                                 needLogin:YES];
//    MyHttpRequest *myHttp2 = [[MyHttpRequest alloc] init];
//    [myHttp2 startRequest:params2
//               hudOnView:nil
//                delegate:self];
    
}

- (void)reqestUploadResouceData:(NSData *)data name:(NSString *)fileName
{
    //base64
    NSData *base64Data = [GTMBase64 encodeData:data];
    NSString *dataString = [[NSString alloc] initWithBytes:[base64Data bytes] length:[base64Data length] encoding:NSUTF8StringEncoding];

    //check
    //[self reqestCheckFileName:fileName];
    
    //upload
    NSDictionary *dic_params = @{@"filename":fileName,
                                 @"imagedata":dataString};
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_resources_upload
                                                    params:dic_params
                                                       tag:ENUM_NetRequest_UploadResouce
                                                   needHud:NO
                                                   hudText:@""
                                                 needLogin:YES];
    MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
    [myHttp startRequest:params
               hudOnView:nil
                delegate:self];
}

- (void)reqestCheckFileName:(NSString *)fileName
{
    //check
    NSDictionary *dic_params = @{@"filename":fileName};
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_resources_check
                                                    params:dic_params
                                                       tag:ENUM_NetRequest_UploadResouceCheck
                                                   needHud:NO
                                                   hudText:@""
                                                 needLogin:YES];
    MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
    [myHttp startRequest:params
               hudOnView:nil
                delegate:self];
}

///////////

- (void)isSuccessEquals:(RequestResult *)result
{
    NSLog(@"isSuccessEquals");
    switch (result.tag) {
        case ENUM_NetRequest_UploadLocal:
        {
            NSDictionary *dic = result.myData;
            NSString *response = [dic valueForKey:ResponseMessKey];
            if ([response isEqualToString:@"标记用户位置成功"]) {
                NSLog(@"标记用户位置成功");
            }
            else if([response isEqualToString:@"标记用户位置失败"])
            {
                NSString *error = [dic valueForKey:@"失败原因"];
                //[Common alert4error:error tag:0 delegate:nil];
            }
            break;
        }
        case ENUM_NetRequest_UploadLocalGroup:
        {
            NSDictionary *dic = result.myData;
            NSString *response = [dic valueForKey:ResponseMessKey];
            if ([response isEqualToString:@"标记群组位置成功"]) {
                NSLog(@"标记群组位置成功");
            }
            else if([response isEqualToString:@"标记群组位置失败"])
            {
                NSString *error = [dic valueForKey:@"失败原因"];
                //[Common alert4error:error tag:0 delegate:nil];
            }
            break;
        }
        case ENUM_NetRequest_UploadResouceCheck:
        {
            NSDictionary *dic = result.myData;
            NSString *response = [dic valueForKey:ResponseMessKey];
            if ([response isEqualToString:@"查找成功"]) {
                NSLog(@"查找成功");
                BOOL exists = [[dic valueForKey:@"exists"] boolValue];
                if (exists) {
                    NSLog(@"had");
                }
                else
                {
                    NSLog(@"no have");
                }
            }
            else if([response isEqualToString:@"查找失败"])
            {
                NSString *error = [dic valueForKey:@"失败原因"];
                //[Common alert4error:error tag:0 delegate:nil];
            }
            break;
        }
        case ENUM_NetRequest_UploadResouce:
        {
            NSDictionary *dic = result.myData;
            NSString *response = [dic valueForKey:ResponseMessKey];
            if ([response isEqualToString:@"图片上传成功"]) {
                NSLog(@"图片或者音频上传成功");
            }
            else if([response isEqualToString:@"图片上传失败"])
            {
                NSLog(@"图片或者音频图片上传失败");
                NSString *error = [dic valueForKey:@"失败原因"];
                NSLog(@"error==%@", error);
            }
            break;
        }
        default:
            break;
    }
}

@end
