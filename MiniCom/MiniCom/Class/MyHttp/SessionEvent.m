//
//  SessionEvent.m
//  MiniCom
//
//  Created by wlp on 14-6-15.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "SessionEvent.h"
#import "AccountManager.h"
#import "MyHttpRequest.h"
#import "ASIFormDataRequest.h"
#import "Params4Http.h"
#import "DBHelper.h"
#import "MyNetManager.h"

@implementation SessionEvent

static SessionEvent *object = nil;

+ (SessionEvent *)SharedInstance
{
    @synchronized(self)
    {
        if (object == nil)
        {
            object = [[SessionEvent alloc] init];
        }
    }
    return object;
}

- (void)setSessionEventRequestStart:(BOOL)start
{
    _start = YES;
    if (start) {
        [self sendSessionEventRequest];
    }
    else
    {
        
    }
}

- (void)sendSessionEventRequest
{
    if (![MyNetManager SharedInstance].isNetWork) {
        return;
    }
//    if ([[AccountManager SharedInstance].username length]>0) {
//    }
//    else
//    {
//        return;
//    }
    if (_start) {
        Params4Http *params = [[Params4Http alloc] initWithUrl:URL_session_event
                                                        params:nil
                                                           tag:1
                                                       needHud:NO
                                                       hudText:@""
                                                     needLogin:YES];
        MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
        myHttp.timeOut = 60.0;
        [myHttp startRequest:params
                   hudOnView:nil
                    delegate:self];
    }
}

- (void)isSuccessEquals:(RequestResult *)result
{
    NSLog(@"session_event isSuccessEquals");
    //[self sendSessionEventRequest];
    [self performSelector:@selector(sendSessionEventRequest) withObject:nil afterDelay:1.0];

    NSDictionary *dic = result.myData;
    NSString *response = [dic valueForKey:ResponseMessKey];
    if ([response isEqualToString:@"成功"]) {
        NSLog(@"session_event成功");
        //event: "message" || "newfriend" || "friendaccept"
        NSString *event = [dic valueForKey:@"event"];
        NSDictionary *contentDic = [dic valueForKey:@"event_content"];
        if ([event isEqualToString:@"message"]) {
            NSArray *messAry = [contentDic valueForKey:@"message"];
            for (NSString *messStr in messAry) {
                /*
                 {\"contentType\":\"text\",
                 \"sendType\":\"point\",
                 \"phone\":\"18510248995\",
                 \"content\":\"H\U597d\U7687\U51a0\U4e2aH\U597d\",
                 \"time\":1402807384510,
                 \"phoneto\":\"[\\\"13488838432\\\"]\"}
                 */
                //NSLog(@"messDic==%@", messDic);
                NSDictionary *messDic = [messStr objectFromJSONString];
                
                NSString *fromPhone = [messDic valueForKey:@"phone"];
                NSString *contentType = [messDic valueForKey:@"contentType"];
                NSString *time = [messDic valueForKey:@"time"];
                NSString *content = [messDic valueForKey:@"content"];
                NSLog(@"\n fromPhone==%@,\n contentType==%@,\n time==%@,\n content==%@", fromPhone, contentType, time, content);
                
                NSString *phoneto = @"";
//                NSString *phonetoStr = [messDic valueForKey:@"phoneto"];
//                NSArray *phonetoAry = [phonetoStr objectFromJSONString];
//                if (phonetoAry && [phonetoAry count] > 0) {
//                    phoneto = [phonetoAry objectAtIndex:0];
//                }
                phoneto = [AccountManager SharedInstance].username;
                NSLog(@"phoneto==%@", phoneto);

                ChatMessData *data = [[ChatMessData alloc] init];
                data.contentType = [messDic valueForKey:@"contentType"];
                data.sendType = [messDic valueForKey:@"sendType"];
                data.phone = phoneto;
                data.phoneToOrFrom = [messDic valueForKey:@"phone"];
                data.content = [messDic valueForKey:@"content"];
                data.time = [messDic valueForKey:@"time"];
                data.isRead = 0;
                data.isSend = 0;
                if ([messDic valueForKey:@"gid"]) {
                    data.gid = [NSString stringWithFormat:@"%@",[messDic valueForKey:@"gid"]];
                }

                [[DBHelper sharedInstance] insertChatMess:data];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:SessionEvent_MessageNotification object:nil];
        }
        else if ([event isEqualToString:@"userinformationchanged"]) {
            NSLog(@"**********session_event userinformationchanged***************\n");
            //{"提示信息":"成功","event":"userinformationchanged","event_content":{"phone":"18510248995"}}
            NSString *phone = [contentDic valueForKey:@"phone"];
            NSLog(@"event_content phone==%@", phone);
            [[AccountManager SharedInstance] getAccoutInfoRequest];
        }
        else if ([event isEqualToString:@"newfriend"]) {
            NSLog(@"**********session_event newfriend***************\n");
            [[NSNotificationCenter defaultCenter] postNotificationName:SessionEvent_Own object:nil];
        }
        else if ([event isEqualToString:@"friendaccept"]) {
            NSLog(@"**********session_event friendaccept***************\n");
            [[NSNotificationCenter defaultCenter] postNotificationName:SessionEvent_Own object:nil];
        }
        else if ([event isEqualToString:@"groupstatuschanged"]) {
            NSLog(@"**********session_event groupstatuschanged***************\n");
            //创建时 {"提示信息":"成功","event":"groupstatuschanged","event_content":{"gid":314,"operation":true}}
            //退出时 {"提示信息":"成功","event":"groupstatuschanged","event_content":{"gid":312,"operation":false}}
            [[NSNotificationCenter defaultCenter] postNotificationName:SessionEvent_Group object:nil];
        }
        else if ([event isEqualToString:@"groupinformationchanged"]) {
            NSLog(@"**********session_event groupinformationchanged***************\n");
            //修改名字时 ||  {"提示信息":"成功","event":"groupinformationchanged","event_content":{"gid":312}}
            [[NSNotificationCenter defaultCenter] postNotificationName:SessionEvent_Group object:nil];
        }
        else if ([event isEqualToString:@"groupmemberchanged"]) {
            NSLog(@"**********session_event groupmemberchanged***************\n");
            //添加 移除 成员 ||  {"提示信息":"成功","event":"groupmemberchanged","event_content":{"gid":247}}
            [[NSNotificationCenter defaultCenter] postNotificationName:SessionEvent_Group object:nil];
        }
        else
        {
            NSLog(@"**********Notfound session_event type**********");
            [[NSNotificationCenter defaultCenter] postNotificationName:SessionEvent_Own object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:SessionEvent_Group object:nil];
        }
    }
    else if([response isEqualToString:@"失败"])
    {
        NSLog(@"session_event 失败");
        NSString *error = [dic valueForKey:@"失败原因"];
        NSLog(@"error==%@", error);
    }
}

- (void)customFailed:(ASIHTTPRequest *)request
{
    //[self sendSessionEventRequest];
    [self performSelector:@selector(sendSessionEventRequest) withObject:nil afterDelay:1.0];

    NSLog(@"session_event customFailed");
}

@end
