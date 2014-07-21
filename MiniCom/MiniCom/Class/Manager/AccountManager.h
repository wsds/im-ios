//
//  AccountManager.h
//  MiniCom
//
//  Created by wlp on 14-5-18.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AccountData;
@class LocalData;

//账户信息
#define ACCOUNT_USERNAME    @"MINICOM_UsernameInKeychain"
#define ACCOUNT_PASSWORD    @"MINICOM_PasswordInKeychain"
#define ACCOUNT_UID         @"MINICOM_UidInKeychain"
#define ACCOUNT_ACCESSKEY   @"MINICOM_AccessKeyInKeychain"
#define ACCOUNT_PBKEY       @"MINICOM_PbKeyInKeychain"

#define ACCOUNT_LOCAL_LAT        @"MINICOM_LOCAL_LAT"
#define ACCOUNT_LOCAL_LONG       @"MINICOM_LOCAL_LONG"

#define ACCOUNT_INFO      @"MINICOM_InfoInKeychain"

@interface AccountManager : NSObject

@property (assign, nonatomic) BOOL isLogin;

@property (retain, nonatomic) NSString *username;
@property (retain, nonatomic) NSString *password;
@property (retain, nonatomic) NSString *uid;
@property (retain, nonatomic) NSString *accessKey;
@property (retain, nonatomic) NSString *pbKey;

@property(nonatomic, retain) NSString *longitude;
@property(nonatomic, retain) NSString *latitude;
@property(nonatomic, retain) NSString *radius;

@property (retain, nonatomic) AccountData *userInfoData;

@property (retain, nonatomic) NSArray *friendsAry;

@property (retain, nonatomic) NSMutableArray *circleAry;

+ (AccountManager *)SharedInstance;

+ (BOOL)getCurUserPraiseYorN:(NSArray *)array;

- (void)setAndSaveUsername:(NSString *)username;
- (void)setAndSavePassword:(NSString *)password;

- (void)setLocalLat:(NSString *)latStr longitude:(NSString *)longStr;

- (void)setAndSaveAccountInfo:(AccountData *)account;

- (void)setAndUid:(NSString *)uid
        accesskey:(NSString *)accesskey
            pbkey:(NSString *)pbkey;

- (void)setLogout;

- (void)getAccoutInfoRequest;



@end
