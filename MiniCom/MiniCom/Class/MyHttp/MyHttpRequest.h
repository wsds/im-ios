//
//  MyHttpRequest.h
//  MiniCom
//
//  Created by wlp on 14-5-19.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "UrlHeader.h"

@class ASIFormDataRequest;
@class ASIHTTPRequest;
@class MBProgressHUD;

#import "Params4Http.h"
#import "RequestResult.h"

@protocol MyHttpDelegate <NSObject>
// 代理方法
@optional
- (void)customFailed:(ASIHTTPRequest *)request;

@required
- (void)isSuccessEquals:(RequestResult *)result;

@end

@protocol ASIHTTPRequestDelegate;

@interface MyHttpRequest : NSObject<ASIHTTPRequestDelegate>
{
    
}
@property (assign, nonatomic) id<MyHttpDelegate> delegate;
@property (retain, nonatomic) MBProgressHUD *hud;
@property (assign, nonatomic) BOOL needHud;
@property (assign, nonatomic) BOOL needLogin;
@property (assign, nonatomic) float timeOut;


- (void)startRequest:(Params4Http *)params
           hudOnView:(UIView *)view
            delegate:(id<MyHttpDelegate>)delegate;

@end
