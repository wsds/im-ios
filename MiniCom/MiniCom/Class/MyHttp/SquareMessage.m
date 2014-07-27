//
//  SquareMessage.m
//  MiniCom
//
//  Created by wlp on 14-6-20.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "SquareMessage.h"
#import "AccountManager.h"
#import "MyHttpRequest.h"
#import "ASIFormDataRequest.h"
#import "Params4Http.h"
#import "DBHelper.h"
#import "SquareManager.h"
#import "MyNetManager.h"

#import "GCDAsyncSocket.h"

@implementation SquareMessage

static SquareMessage *object = nil;

+ (SquareMessage *)SharedInstance
{
    @synchronized(self)
    {
        if (object == nil)
        {
            object = [[SquareMessage alloc] init];
        }
    }
    return object;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)setSquareMessageRequestStart:(BOOL)start
{
    _start = YES;
    if (start) {
        [self sendGetSquareMessageRequest];
    }
    else
    {
        
    }
}

- (void)sendGetSquareMessageRequest
{
    if (_start) {
        if (![MyNetManager SharedInstance].isNetWork) {
            return;
        }
#warning gid
        NSString *flagStr = [SquareManager SharedInstance].squareFlag;
        NSDictionary *dic_params = @{@"gid":@"98", @"flag":flagStr};
        Params4Http *params = [[Params4Http alloc] initWithUrl:URL_square_getsquaremessage
                                                        params:dic_params
                                                           tag:1
                                                       needHud:NO
                                                       hudText:@""
                                                     needLogin:YES];
        MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
        myHttp.timeOut = TimeOutSecond;
        [myHttp startRequest:params
                   hudOnView:nil
                    delegate:self];
        
//        //
//        dispatch_queue_t mainQueue = dispatch_get_main_queue();
//        asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
//        NSString *host = HOST;
//		uint16_t port = PORT;
//		NSLog(@"Connecting to \"%@\" on port %hu...", host, port);
//		NSError *error = nil;
//		if (![asyncSocket connectToHost:host onPort:port error:&error])
//		{
//			NSLog(@"Error connecting: %@", error);
//		}
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Socket Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	NSLog(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
	
    //	NSLog(@"localHost :%@ port:%hu", [sock localHost], [sock localPort]);
	
    [sock performBlock:^{
        if ([sock enableBackgroundingOnSocket])
        {
            NSLog(@"Enabled backgrounding on socket");
        }
        else
            NSLog(@"Enabling backgrounding failed!");
    }];
    
    // Configure SSL/TLS settings
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithCapacity:3];
    
    //[settings setObject:HOST
    //             forKey:(NSString *)kCFStreamSSLPeerName];
    //NSLog(@"Starting TLS with settings:\n%@", settings);
    
    [sock startTLS:settings];
    [sock performBlock:^{
        if ([sock enableBackgroundingOnSocket])
        {
            NSLog(@"Enabled backgrounding on socket");
        }
        else
            NSLog(@"Enabling backgrounding failed!");
    }];
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
	NSLog(@"socketDidSecure:%p", sock);
	
	//NSString *requestStr = [NSString stringWithFormat:@"GET / HTTP/1.1\r\nHost: %@\r\n\r\n", HOST];
	//NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
	
	//[sock writeData:requestData withTimeout:-1 tag:0];
	//[sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	NSLog(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	NSLog(@"socket:%p didReadData:withTag:%ld", sock, tag);
	
	NSString *httpResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	NSLog(@"HTTP Response:\n%@", httpResponse);
	
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
}

- (void)isSuccessEquals:(RequestResult *)result
{
    NSLog(@"sendGetSquareMessageRequest isSuccessEquals");
    [self performSelector:@selector(sendGetSquareMessageRequest) withObject:nil afterDelay:DurSecond];
    
    NSDictionary *dic = result.myData;
    NSString *response = [dic valueForKey:ResponseMessKey];
    if ([response isEqualToString:@"获取广播成功"]) {
        NSLog(@"sendGetSquareMessageRequest成功");
        
        [self setSquareWithDic:dic];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:SquareEvent_MessageNotification object:nil];
    }
    else if([response isEqualToString:@"获取广播失败"])
    {
        NSLog(@"sendGetSquareMessageRequest 获取广播失败");
        NSString *error = [dic valueForKey:@"失败原因"];
        NSLog(@"error==%@", error);
    }
}

- (void)setSquareWithDic:(NSDictionary *)dic
{
    NSString *flag = [dic valueForKey:@"flag"];
    NSLog(@"flag==%@", flag);
    [SquareManager SharedInstance].squareFlag = flag;
    
    NSArray *messageAry = [dic valueForKey:@"messages"];
    
    //存入数据库
    [self insertSquareMessAry:messageAry];
    
    //提取数据
    NSArray *squareAry = [[DBHelper sharedInstance] getSquareMessage];
    
    //解析 设置到内存
    [self setSquareDataWithMessAry:squareAry];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:SquareEvent_MessageNotification object:nil];

    });
}

//- (void)insertSquareMessAry:(NSArray *)messageAry
//{
//    for (int i=0; i<[messageAry count]; i++) {
//       NSString *squareStr = [messageAry objectAtIndex:i];
//        NSDictionary *squareDic = [squareStr objectFromJSONString];
//
//        NSString *gmid = [NSString stringWithFormat:@"%@",[squareDic valueForKey:@"gmid"]];
//        [[DBHelper sharedInstance] insertOrUpdateSquareStr:squareStr gmid:gmid];
//    }
//}

- (void)insertSquareMessAry:(NSArray *)messageAry
{
    for (int i=0; i<[messageAry count]; i++) {
        NSDictionary *squareDic = nil;
        NSString *objectStr = @"";
        
        NSObject *squareObject = [messageAry objectAtIndex:i];
        if ([squareObject isKindOfClass:[NSString class]]) {
            objectStr = (NSString *)squareObject;
            squareDic = [objectStr objectFromJSONString];
        }
        else if ([squareObject isKindOfClass:[NSDictionary class]])
        {
            squareDic = (NSDictionary *)squareObject;
            objectStr = [squareDic JSONString];
        }
        else
        {
            NSLog(@"not found class type");
            return;
        }
        
        NSString *gmid = [NSString stringWithFormat:@"%@",[squareDic valueForKey:@"gmid"]];
        [[DBHelper sharedInstance] insertOrUpdateSquareStr:objectStr gmid:gmid];
    }
}

- (void)setSquareDataWithMessAry:(NSArray *)messageAry
{
    NSMutableArray *Ary1 = [[NSMutableArray alloc] init];
    NSMutableArray *Ary2 = [[NSMutableArray alloc] init];
    NSMutableArray *Ary3 = [[NSMutableArray alloc] init];
    NSMutableArray *Ary4 = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[messageAry count]; i++) {
        NSString *squareStr = [messageAry objectAtIndex:i];
        NSDictionary *squareDic = [squareStr objectFromJSONString];
        NSString *gmid = [NSString stringWithFormat:@"%@",[squareDic valueForKey:@"gmid"]];
        NSString *sendType = [squareDic valueForKey:@"sendType"];
        NSString *messageType = [squareDic valueForKey:@"messageType"];
        NSString *contentType = [squareDic valueForKey:@"contentType"];
        NSString *cover = [squareDic valueForKey:@"cover"];
        NSString *phone = [squareDic valueForKey:@"phone"];
        NSString *nickName = [squareDic valueForKey:@"nickName"];
        NSString *head = [squareDic valueForKey:@"head"];
        NSString *gid = [NSString stringWithFormat:@"%@",[squareDic valueForKey:@"gid"]];
        NSString *time = [NSString stringWithFormat:@"%@", [squareDic valueForKey:@"time"]];
        NSArray *praiseusers = [squareDic valueForKey:@"praiseusers"];
        NSArray *content = [squareDic valueForKey:@"content"];
        
        NSMutableArray *contentAry = [[NSMutableArray alloc] init];
        for (int i=0; i<[content count]; i++) {
            NSDictionary *contentDic = [content objectAtIndex:i];
            NSString *type = [contentDic valueForKey:@"type"];
            NSString *details = [contentDic valueForKey:@"details"];
            SquareContentData *contentData = [[SquareContentData alloc] init];
            contentData.type = type;
            contentData.details = details;
            [contentAry addObject:contentData];
        }
        
        SquareMessData *sData = [[SquareMessData alloc] init];
        sData.gmid = gmid;
        sData.sendType = sendType;
        sData.messageType = messageType;
        sData.contentType = contentType;
        sData.cover = cover;
        sData.phone = phone;
        sData.nickName = nickName;
        sData.head = head;
        sData.gid = gid;
        sData.time = time;
        sData.praiseusers = praiseusers;
        
        sData.content = contentAry;
        
        if ([messageType isKindOfClass:[NSArray class]]) {
            [Ary4 addObject:sData];
        }
        else
        {
            if ([messageType isEqualToString:@"精华"]) {
                [Ary1 addObject:sData];
            }
            else if ([messageType isEqualToString:@"活动"])
            {
                [Ary2 addObject:sData];
            }
            else if ([messageType isEqualToString:@"吐槽"])
            {
                [Ary3 addObject:sData];
            }
            else
            {
                [Ary4 addObject:sData];
            }
        }
    }
    [SquareManager SharedInstance].square_huodong_ary = Ary2;
    [SquareManager SharedInstance].square_jinghua_ary = Ary1;
    [SquareManager SharedInstance].square_quanbu_ary = Ary4;
    [SquareManager SharedInstance].square_tucao_ary = Ary3;
}

- (void)customFailed:(ASIHTTPRequest *)request
{
    [self performSelector:@selector(sendGetSquareMessageRequest) withObject:nil afterDelay:DurSecond];
    
    NSLog(@"sendGetSquareMessageRequest customFailed");
}

@end
