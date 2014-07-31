//
//  MyHttpRequest.m
//  MiniCom
//
//  Created by wlp on 14-5-19.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "MyHttpRequest.h"
#import "MyNetManager.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"
#import "Common.h"
#import "AccountManager.h"

@implementation MyHttpRequest

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.timeOut = 10.0;
    }
    return self;
}

//dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//dispatch_async(dispatch_get_main_queue(), ^(void) {

- (void)startRequest:(Params4Http *)params
           hudOnView:(UIView *)view
            delegate:(id<MyHttpDelegate>)delegate
{
    if (![MyNetManager SharedInstance].isNetWork) {
        return;
    }
    
    
    self.delegate = delegate;
    self.needLogin = params.needLogin;
    self.needHud = params.needHud;
    
    NSString *phone = [AccountManager SharedInstance].username;
    NSString *accKey = [AccountManager SharedInstance].accessKey;
    accKey = TempCommonAccKey;
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionaryWithDictionary:@{@"phone":phone, @"accessKey":accKey}];
    if (self.needLogin) {
        if ([[AccountManager SharedInstance].username length]>0) {
            [requestDic addEntriesFromDictionary:params.params];
        }
        else
        {
            NSLog(@"No phone cannot to request!!!");
            return;
        }
    }
    else
    {
        requestDic = params.params;
    }
    
    if (requestDic) {
        //hud
        if (_needHud && view) {
            self.hud = [[MBProgressHUD alloc] initWithView:view];
            _hud.removeFromSuperViewOnHide = YES;
            _hud.labelText = params.hudText.length == 0?DefaultMess:params.hudText;
            [view addSubview:_hud];
            [_hud show:NO];
        }
        //asi
        [self requestUrl:params.url dic:requestDic tag:params.tag];
    }
}

- (void)requestUrl:(NSString *)url dic:(NSDictionary *)dic tag:(int)tag
{
    //NSLog(@"request url==%@", url);
    //NSLog(@"requestDic==%@", dic);

    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    request.timeOutSeconds = self.timeOut;
    //request.delegate = self;
    request.tag = tag;
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setPostValue:obj forKey:key];
    }];
    //callback
    [request setCompletionBlock :^{
        if (_needHud) {
            [_hud hide:YES];
        }
        [self requestFinished:request];
    }];
    [request setFailedBlock :^{
        if (_needHud) {
            [_hud hide:YES];
        }
        NSLog ( @"block error:%@" ,[[request error] userInfo ]);
        [self requestFailed:request];
    }];
    [request startAsynchronous];
}


- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"requestFailed");
    if (_delegate && [_delegate respondsToSelector:@selector(customFailed:)]) {
        [_delegate customFailed:request];
    }else{
        //[Common alert4error:@"没有网络连接" tag:0 delegate:nil];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSLog(@"requestFinished");
    RequestResult *result = [self getResultFromRequest:request];
    if (_delegate && [_delegate respondsToSelector:@selector(isSuccessEquals:)]) {
        [_delegate isSuccessEquals:result];
    }else{
        //[Common alert4error:result.message tag:0 delegate:nil];
    }
}

- (RequestResult *)getResultFromRequest:(ASIHTTPRequest *)request{
    NSString *str_r = [request responseString];
    //NSLog(@"responseString==%@\n", str_r);

    NSDictionary *dic = [str_r objectFromJSONString];
    //NSLog(@"result dic==%@", dic);
    
    // 存储对象
    RequestResult *rs = [[RequestResult alloc] init];
    rs.tag = request.tag;
    rs.message = str_r;
    rs.myData = dic;
    return rs;
}

@end
