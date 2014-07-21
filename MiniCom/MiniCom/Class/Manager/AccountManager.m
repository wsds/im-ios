//
//  AccountManager.m
//  MiniCom
//
//  Created by wlp on 14-5-18.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "AccountManager.h"
#import "DBHelper.h"
#import "MyHttpRequest.h"
#import "AnalyTools.h"
#import "AccountData.h"
#import "LocalData.h"
#import "SessionEvent.h"
#import "SquareMessage.h"

#define NearRadius @"10000"

@implementation AccountManager

static AccountManager *object = nil;

+ (AccountManager *)SharedInstance
{
    @synchronized(self)
    {
        if (object == nil)
        {
            object = [[AccountManager alloc] init];
        }
    }
    return object;
}

+ (BOOL)getCurUserPraiseYorN:(NSArray *)array
{
    for (NSString *phone in array) {
        if ([phone isEqualToString:[AccountManager SharedInstance].username]) {
            return  YES;
        }
    }
    return NO;
}

- (id)init
{
    self = [super init];
    if (self){
        NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
        self.username = [de objectForKey:ACCOUNT_USERNAME];
        self.password = [de objectForKey:ACCOUNT_PASSWORD];
        self.uid = [de objectForKey:ACCOUNT_UID];
        self.accessKey = [de objectForKey:ACCOUNT_ACCESSKEY];
        self.pbKey = [de objectForKey:ACCOUNT_PBKEY];
        self.latitude = [de objectForKey:ACCOUNT_LOCAL_LAT];
        self.longitude = [de objectForKey:ACCOUNT_LOCAL_LONG];
        
        if (!self.username) {
            self.username = @"";
        }
        if (!self.password) {
            self.password = @"";
        }
        if (!self.uid) {
            self.uid = @"";
        }
        if (!self.accessKey) {
            self.accessKey = @"";
        }
        if (!self.pbKey) {
            self.pbKey = @"";
        }
        if (!self.latitude) {
            self.latitude = @"";
        }
        if (!self.longitude) {
            self.longitude = @"";
        }
        //self.latitude = @"39.989117";
        //self.longitude = @"116.420232";

        self.radius = NearRadius;

        _userInfoData = [[AccountData alloc] init];
        self.userInfoData = [[DBHelper sharedInstance] getAccountByPhone:self.username];
        
        _circleAry = [[NSMutableArray alloc] init];
        
    }
    return  self;
}

- (void)setAndSaveUsername:(NSString *)username
{
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    [de setObject:username forKey:ACCOUNT_USERNAME];
    [de synchronize];
    
    self.username = username;
}

- (void)setAndSavePassword:(NSString *)password
{
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    [de setObject:password forKey:ACCOUNT_PASSWORD];
    [de synchronize];
    
    self.password = password;
}

- (void)setLocalLat:(NSString *)latStr longitude:(NSString *)longStr
{
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    [de setObject:latStr forKey:ACCOUNT_LOCAL_LAT];
    [de setObject:longStr forKey:ACCOUNT_LOCAL_LONG];
    [de synchronize];
    
    self.latitude = latStr;
    self.longitude = longStr;
}

- (void)setAndSaveAccountInfo:(AccountData *)account
{
//    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
//    [de setObject:account forKey:ACCOUNT_INFO];
//    [de synchronize];
    
    [[DBHelper sharedInstance] insertOrUpdateAccount:account];
    
    self.userInfoData = account;
}

- (void)setAndUid:(NSString *)uid
        accesskey:(NSString *)accesskey
            pbkey:(NSString *)pbkey
{
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    [de setObject:uid forKey:ACCOUNT_UID];
    [de setObject:accesskey forKey:ACCOUNT_ACCESSKEY];
    [de setObject:pbkey forKey:ACCOUNT_PBKEY];
    [de synchronize];
    
    self.uid = uid;
    self.accessKey = accesskey;
    self.pbKey = pbkey;
}

//
#pragma mark NetRequest
- (void)getAccoutInfoRequest
{
    NSString *phone = self.username;
    NSString *phonetoAryString = [@[phone] JSONString];
    NSDictionary *dic_params = @{@"target":phonetoAryString};
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_account_get
                                                    params:dic_params
                                                       tag:0
                                                   needHud:YES
                                                   hudText:@""
                                                 needLogin:YES];
    MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
    [myHttp startRequest:params
               hudOnView:nil
                delegate:self];
}


- (void)setLogout
{    
    [self setAndSaveUsername:@""];
    [self setAndSavePassword:@""];
    
    [[SessionEvent SharedInstance] setSessionEventRequestStart:NO];
    [[SquareMessage SharedInstance] setSquareMessageRequestStart:NO];
}

- (void)isSuccessEquals:(RequestResult *)result
{
    //获取信息
    if (result.tag == 0) {
        NSDictionary *dic = result.myData;
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"获取用户信息成功"]) {
            NSLog(@"获取用户信息成功");
            NSArray *ary = [dic valueForKey:@"accounts"];
            if (ary && [ary count] > 0) {
                NSDictionary *accountDic = [ary objectAtIndex:0];
                AccountData *account = [AnalyTools analyAccount:accountDic];
                [[AccountManager SharedInstance] setAndSaveAccountInfo:account];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:UserinfoChangedNotification object:nil];
            }
        }
        else if([response isEqualToString:@"获取用户信息失败"])
        {
            NSString *error = [dic valueForKey:@"失败原因"];
            NSLog(@"获取 当前 用户信息失败 error==%@", error);
            [Common alert4error:error tag:0 delegate:nil];
        }
    }
}

@end
