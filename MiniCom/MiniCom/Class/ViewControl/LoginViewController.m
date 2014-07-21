//
//  LoginViewController.m
//  MiniCom
//
//  Created by wlp on 14-5-18.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "LoginViewController.h"
#import "BaseTitleView.h"
#import "Common.h"

#import "Login_normalView.h"
#import "Login_codeView.h"
#import "Register_UserView.h"
#import "Register_CodeView.h"
#import "Register_PasswordView.h"

#import "MyHttpRequest.h"
#import "MyNetManager.h"
#import "AccountManager.h"
#import "AccountData.h"
#import "SessionEvent.h"

#import "RSA.h"

#define AnimationDur 0.3

enum
{
    ENUM_Request_Login,
    ENUM_Request_CodeLogin,
    ENUM_Request_CodeLogin_NewReg,
    ENUM_Request_SendLogin_Code,
    ENUM_Request_SendRegister_Code,
    ENUM_Request_ChangePassWord
};

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //bg
    [Common addImageName:@"background2.jpg" onView:self.view frame:[Common RectMakex:0 y:0 w:1.0 h:1.0 onSuperBounds:kScreen_Frame]];
    
    //
    showFrame1 = [Common RectMakex:0.05 y:0.05 w:0.9 h:0.5 onSuperBounds:kScreen_Frame];
    _login_normalView = [[Login_normalView alloc] initWithFrame:showFrame1
                                                          title:@"登录"
                                                       needBack:NO
                                                       delegate:self
                                                            tag:ENUM_LOGIN_VIEW_NORMAL];
    [self.view addSubview:_login_normalView];
    
    showFrame2 = [Common RectMakex:0.05 y:0.05 w:0.9 h:0.4 onSuperBounds:kScreen_Frame];
    _login_codeView = [[Login_codeView alloc] initWithFrame:showFrame2
                                                          title:@"验证码登录"
                                                       needBack:YES
                                                       delegate:self
                                                            tag:ENUM_LOGIN_VIEW_CODE];
    [self.view addSubview:_login_codeView];
    
    showFrame3 = [Common RectMakex:0.05 y:0.05 w:0.9 h:0.3 onSuperBounds:kScreen_Frame];
    _reg_userView = [[Register_UserView alloc] initWithFrame:showFrame3
                                                      title:@"输入手机号"
                                                   needBack:YES
                                                   delegate:self
                                                        tag:ENUM_REG_VIEW_USER];
    [self.view addSubview:_reg_userView];
    
    showFrame4 = [Common RectMakex:0.05 y:0.05 w:0.9 h:0.4 onSuperBounds:kScreen_Frame];
    _reg_codeView = [[Register_CodeView alloc] initWithFrame:showFrame4
                                                       title:@"输入验证码"
                                                    needBack:YES
                                                    delegate:self
                                                         tag:ENUM_REG_VIEW_CODE];
    [self.view addSubview:_reg_codeView];
    
    showFrame5 = [Common RectMakex:0.05 y:0.05 w:0.9 h:0.3 onSuperBounds:kScreen_Frame];
    _reg_passwordView = [[Register_PasswordView alloc] initWithFrame:showFrame5
                                                       title:@"设置密码"
                                                    needBack:YES
                                                    delegate:self
                                                         tag:ENUM_REG_VIEW_PASSWORD];
    [self.view addSubview:_reg_passwordView];
    
    //
    [self setDefaultView];
}

- (void)setDefaultView
{
    [self showViewTag:ENUM_LOGIN_VIEW_NORMAL animation:NO isUp:NO];
    [self hideViewTag:ENUM_LOGIN_VIEW_CODE animation:NO isUp:NO];
    [self hideViewTag:ENUM_REG_VIEW_USER animation:NO isUp:NO];
    [self hideViewTag:ENUM_REG_VIEW_CODE animation:NO isUp:NO];
    [self hideViewTag:ENUM_REG_VIEW_PASSWORD animation:NO isUp:NO];
}

- (void)showViewTag:(int)tag
          animation:(BOOL)animation
               isUp:(BOOL)isUp
{
    BaseTitleView *view = nil;
    CGRect frame;
    switch (tag) {
        case ENUM_LOGIN_VIEW_NORMAL:
            view = _login_normalView;
            frame = showFrame1;
            break;
        case ENUM_LOGIN_VIEW_CODE:
            view = _login_codeView;
            frame = showFrame2;
            break;
        case ENUM_REG_VIEW_USER:
            view = _reg_userView;
            frame = showFrame3;
            break;
        case ENUM_REG_VIEW_CODE:
            view = _reg_codeView;
            frame = showFrame4;
            break;
        case ENUM_REG_VIEW_PASSWORD:
            view = _reg_passwordView;
            frame = showFrame5;
            break;
        default:
            break;
    }
    if (view) {
        [view show];

        if (animation) {
            CGRect beginFrame;
            if (isUp) {
                beginFrame = CGRectMake(frame.origin.x,
                                               kScreen_Height,
                                               frame.size.width,
                                               frame.size.height);
            }
            else
            {
                beginFrame = CGRectMake(frame.origin.x,
                                        -kScreen_Height,
                                        frame.size.width,
                                        frame.size.height);
            }
            view.frame = beginFrame;
            [UIView animateWithDuration:AnimationDur animations:^{
                view.frame = frame;
            }];
        }
        else
        {
            view.frame = frame;
        }
    }
}

- (void)hideViewTag:(int)tag
          animation:(BOOL)animation
               isUp:(BOOL)isUp
{
    BaseTitleView *view = nil;
    CGRect frame;
    switch (tag) {
        case ENUM_LOGIN_VIEW_NORMAL:
            view = _login_normalView;
            frame = showFrame1;
            break;
        case ENUM_LOGIN_VIEW_CODE:
            view = _login_codeView;
            frame = showFrame2;
            break;
        case ENUM_REG_VIEW_USER:
            view = _reg_userView;
            frame = showFrame3;
            break;
        case ENUM_REG_VIEW_CODE:
            view = _reg_codeView;
            frame = showFrame4;
            break;
        case ENUM_REG_VIEW_PASSWORD:
            view = _reg_passwordView;
            frame = showFrame5;
            break;
        default:
            break;
    }
    if (view) {
        [view hide];
        
        CGRect endFrame;
        if (isUp) {
            endFrame = CGRectMake(frame.origin.x,
                                    -kScreen_Height,
                                    frame.size.width,
                                    frame.size.height);
        }
        else
        {
            endFrame = CGRectMake(frame.origin.x,
                                    kScreen_Height,
                                    frame.size.width,
                                    frame.size.height);
        }
        if (animation) {
            view.frame = frame;
            [UIView animateWithDuration:AnimationDur animations:^{
                view.frame = endFrame;
            }];
        }
        else
        {
            view.frame = endFrame;
        }
    }
}

//callback
#pragma mark-
#pragma mark callback

- (void)registerAction
{
    [self hideViewTag:ENUM_LOGIN_VIEW_NORMAL animation:YES isUp:YES];
    [self showViewTag:ENUM_REG_VIEW_USER animation:YES isUp:YES];
}

- (void)codeLoginAction
{
    [self hideViewTag:ENUM_LOGIN_VIEW_NORMAL animation:YES isUp:YES];
    [self showViewTag:ENUM_LOGIN_VIEW_CODE animation:YES isUp:YES];
}

- (void)baseViewBack:(int)tag
{
    NSLog(@"baseViewBack tag==%d", tag);
    switch (tag) {
        case ENUM_LOGIN_VIEW_NORMAL:
            break;
        case ENUM_LOGIN_VIEW_CODE:
            [self hideViewTag:ENUM_LOGIN_VIEW_CODE animation:YES isUp:NO];
            [self showViewTag:ENUM_LOGIN_VIEW_NORMAL animation:YES isUp:NO];
            break;
        case ENUM_REG_VIEW_USER:
            [self hideViewTag:ENUM_REG_VIEW_USER animation:YES isUp:NO];
            [self showViewTag:ENUM_LOGIN_VIEW_NORMAL animation:YES isUp:NO];
            break;
        case ENUM_REG_VIEW_CODE:
            [self hideViewTag:ENUM_REG_VIEW_CODE animation:YES isUp:NO];
            [self showViewTag:ENUM_REG_VIEW_USER animation:YES isUp:NO];
            break;
        case ENUM_REG_VIEW_PASSWORD:
            [self hideViewTag:ENUM_REG_VIEW_PASSWORD animation:YES isUp:NO];
            [self showViewTag:ENUM_REG_VIEW_CODE animation:YES isUp:NO];
            break;
        default:
            break;
    }
}

- (void)nextBtnCallback:(int)tag
{
    NSLog(@"nextBtnCallback tag==%d", tag);
    switch (tag) {
        case ENUM_LOGIN_VIEW_NORMAL:
            break;
        case ENUM_LOGIN_VIEW_CODE:
            break;
        case ENUM_REG_VIEW_USER:
            [self hideViewTag:ENUM_REG_VIEW_USER animation:YES isUp:YES];
            [self showViewTag:ENUM_REG_VIEW_CODE animation:YES isUp:YES];
            break;
        case ENUM_REG_VIEW_CODE:
            [self hideViewTag:ENUM_REG_VIEW_CODE animation:YES isUp:YES];
            [self showViewTag:ENUM_REG_VIEW_PASSWORD animation:YES isUp:YES];
            break;
        case ENUM_REG_VIEW_PASSWORD:
            
            break;
        default:
            break;
    }
}

////
#pragma mark net method

- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    NSLog(@"用户名 密码登录\n username==%@\n password==%@", username, password);
    if ([username length] > 0) {
        self.userName = username;
        self.passWord = password;
        //密码 哈希
        NSString *shaPass = [password sha1Str];
        NSDictionary *dic_params = @{@"phone":username, @"password":shaPass};
        //NSDictionary *dic_params = @{@"typical": [dic_login JSONString]};
        Params4Http *params = [[Params4Http alloc] initWithUrl:URL_account_auth
                                                        params:dic_params
                                                           tag:ENUM_Request_Login
                                                       needHud:YES
                                                       hudText:@""
                                                     needLogin:NO];
        MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
        [myHttp startRequest:params
                   hudOnView:self.view
                    delegate:self];
    }
    else
    {
        NSLog(@"phone nil");
    }
}

- (void)loginWithUsername:(NSString *)username
                     code:(NSString *)code
             fromRegister:(BOOL)isNewRegister
{
    NSLog(@"用户名 验证码登录\n username==%@\n code==%@", username, code);
    if ([username length] > 0) {
        self.userName = username;

        NSDictionary *dic_params = @{@"phone":username, @"code":code};
        //NSDictionary *dic_params = @{@"typical": [dic_login JSONString]};
        int requestTag = isNewRegister ? ENUM_Request_CodeLogin_NewReg : ENUM_Request_CodeLogin;
        Params4Http *params = [[Params4Http alloc] initWithUrl:URL_account_verifycode
                                                        params:dic_params
                                                           tag:requestTag
                                                       needHud:YES
                                                       hudText:@""
                                                     needLogin:NO];
        MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
        [myHttp startRequest:params
                   hudOnView:self.view
                    delegate:self];
    }
    else
    {
        NSLog(@"phone nil");
    }
}

- (void)sendCodeToPhone:(NSString *)phone usage:(NSString *)usage
{
    NSLog(@"sendCodeToPhone");
    if ([phone length] > 0) {
        NSDictionary *dic_params = @{@"phone":phone, @"usage":usage};
        int requestTag = [usage isEqualToString:@"login"] ? ENUM_Request_SendLogin_Code : ENUM_Request_SendRegister_Code;
        Params4Http *params = [[Params4Http alloc] initWithUrl:URL_account_verifyphone
                                                        params:dic_params
                                                           tag:requestTag
                                                       needHud:YES
                                                       hudText:@""
                                                     needLogin:NO];
        MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
        [myHttp startRequest:params
                   hudOnView:self.view
                    delegate:self];
    }
    else
    {
        NSLog(@"phone nil");
    }
}


- (void)changePasswordRequestOldPass:(NSString *)oldPass newPass:(NSString *)newPass
{
    NSString *nickName = [AccountManager SharedInstance].userInfoData.nickName;
    NSString *sex = [AccountManager SharedInstance].userInfoData.sex;
    NSString *phone = [AccountManager SharedInstance].userInfoData.phone;
    NSString *mainBusiness = [AccountManager SharedInstance].userInfoData.mainBusiness;
    NSString *head = [AccountManager SharedInstance].userInfoData.head;
    NSString *userBackground = [AccountManager SharedInstance].userInfoData.userBackground;
    NSString *password = newPass;
    
    NSDictionary *accountDic = @{@"phone":phone,
                                 @"nickName":nickName,
                                 @"sex":sex,
                                 @"mainBusiness":mainBusiness,
                                 @"head":head,
                                 @"userBackground":userBackground,
                                 @"password":password,};
    NSString *accountStr = [accountDic JSONString];
    
    NSDictionary *dic_params = @{@"oldpassword":oldPass,
                                 @"account":accountStr};
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_account_modify
                                                    params:dic_params
                                                       tag:ENUM_Request_ChangePassWord
                                                   needHud:YES
                                                   hudText:@""
                                                 needLogin:YES];
    MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
    [myHttp startRequest:params
               hudOnView:self.view
                delegate:self];
}

- (void)isSuccessEquals:(RequestResult *)result
{
    NSLog(@"isSuccessEquals");
    switch (result.tag) {
        case ENUM_Request_Login:
        {
            NSLog(@"normal login==%@", result.message);
            NSDictionary *dic = result.myData;
            NSString *response = [dic valueForKey:ResponseMessKey];
            if ([response isEqualToString:@"普通鉴权成功"]) {
                NSLog(@"普通鉴权成功");
                NSString *uid = [dic valueForKey:@"uid"];
                NSString *accessKey = [dic valueForKey:@"accessKey"];
                NSString *PbKey = [dic valueForKey:@"PbKey"];
                
                NSLog(@"\n uid==%@,\n accessKey==%@,\n PbKey==%@\n", uid, accessKey, PbKey);
                [self loginOkToSaveUid:uid accessKey:accessKey pbKey:PbKey];
            }
            else if([response isEqualToString:@"普通鉴权失败"])
            {
                NSString *error = [dic valueForKey:@"失败原因"];
                [Common alert4error:error tag:0 delegate:nil];
            }
            break;
        }
        case ENUM_Request_CodeLogin:
        {
            NSLog(@"code login==%@", result.message);
            NSDictionary *dic = result.myData;
            NSString *response = [dic valueForKey:ResponseMessKey];
            if ([response isEqualToString:@"验证成功"]) {
                NSLog(@"验证成功");
                NSString *uid = [dic valueForKey:@"uid"];
                NSString *accessKey = [dic valueForKey:@"accessKey"];
                NSString *PbKey = [dic valueForKey:@"PbKey"];

                NSLog(@"\n uid==%@,\n accessKey==%@,\n PbKey==%@\n", uid, accessKey, PbKey);
                [self loginOkToSaveUid:uid accessKey:accessKey pbKey:PbKey];
                
                [_login_codeView stopTimer];
            }
            else if([response isEqualToString:@"验证失败"])
            {
                NSString *error = [dic valueForKey:@"失败原因"];
                [Common alert4error:error tag:0 delegate:nil];
            }
            break;
        }
        case ENUM_Request_CodeLogin_NewReg:
        {
            NSLog(@"code login new reg==%@", result.message);
            NSDictionary *dic = result.myData;
            NSString *response = [dic valueForKey:ResponseMessKey];
            if ([response isEqualToString:@"验证成功"]) {
                NSLog(@"验证成功");
                NSString *uid = [dic valueForKey:@"uid"];
                NSString *accessKey = [dic valueForKey:@"accessKey"];
                NSString *PbKey = [dic valueForKey:@"PbKey"];
                
                NSLog(@"\n uid==%@,\n accessKey==%@,\n PbKey==%@\n", uid, accessKey, PbKey);
                //[self loginOkToSaveUid:uid accessKey:accessKey pbKey:PbKey];
                [AccountManager SharedInstance].username = self.userName;
                [AccountManager SharedInstance].uid = uid;
                [AccountManager SharedInstance].accessKey = accessKey;
                [AccountManager SharedInstance].pbKey = PbKey;
                
                [self nextBtnCallback:ENUM_REG_VIEW_CODE];
                [_reg_codeView stopTimer];
            }
            else if([response isEqualToString:@"验证失败"])
            {
                NSString *error = [dic valueForKey:@"失败原因"];
                [Common alert4error:error tag:0 delegate:nil];
            }
            break;
        }
        case ENUM_Request_SendLogin_Code:
        {
            NSLog(@"send login code==%@", result.message);
            NSDictionary *dic = result.myData;
            NSString *response = [dic valueForKey:ResponseMessKey];
            if ([response isEqualToString:@"验证码发送成功"]) {
                NSLog(@"验证码发送成功");
                NSString *phone = [dic valueForKey:@"phone"];
                NSString *code = [dic valueForKey:@"code"];
                NSLog(@"phone==%@, code==%@", phone, code);
                
                if(!_login_codeView.isTiming)
                [_login_codeView startSendCodeTimer];
            }
            else if([response isEqualToString:@"验证码发送失败"])
            {
                NSString *error = [dic valueForKey:@"失败原因"];
                [Common alert4error:error tag:0 delegate:nil];
            }
            break;
        }
        case ENUM_Request_SendRegister_Code:
        {
            NSLog(@"send register code==%@", result.message);
            NSDictionary *dic = result.myData;
            NSString *response = [dic valueForKey:ResponseMessKey];
            if ([response isEqualToString:@"手机号验证成功"]) {
                NSLog(@"手机号验证成功");
                NSString *phone = [dic valueForKey:@"phone"];
                NSString *code = [dic valueForKey:@"code"];
                NSLog(@"phone==%@, code==%@", phone, code);
                
                [self nextBtnCallback:ENUM_REG_VIEW_USER];
                if(!_reg_codeView.isTiming || ![_reg_codeView.registerPhone isEqualToString:phone])
                {
                    [_reg_codeView startSendCodeTimer];
                }
                [_reg_codeView setPhone:phone];
            }
            else if([response isEqualToString:@"手机号验证失败"])
            {
                NSString *error = [dic valueForKey:@"失败原因"];
                [Common alert4error:error tag:0 delegate:nil];
            }
            break;
        }
        case ENUM_Request_ChangePassWord:
        {
            NSDictionary *dic = result.myData;
            NSString *response = [dic valueForKey:ResponseMessKey];
            if ([response isEqualToString:@"修改用户信息成功"]) {
                NSLog(@"修改用户信息成功");

                [self loginOkToSaveUid:[AccountManager SharedInstance].uid
                             accessKey:[AccountManager SharedInstance].accessKey
                                 pbKey:[AccountManager SharedInstance].pbKey];

            }
            else if([response isEqualToString:@"修改用户信息成功失败"])
            {
                NSString *error = [dic valueForKey:@"失败原因"];
                [Common alert4error:error tag:0 delegate:nil];
            }
        }
        default:
            break;
    }
}

- (void)loginOkToSaveUid:(NSString *)uid
               accessKey:(NSString *)accessKey
                   pbKey:(NSString *)pbKey
{
    NSLog(@"username==%@ password==%@, to save uid/access/pbkey", self.userName, self.passWord);
    //[Common alert4error:[NSString stringWithFormat:@"%@ 登录成功", self.userName] tag:0 delegate:nil];
    
    //save account info
    //accessKey = [accessKey stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //[self rsaAcc: accessKey pbKey:pbKey];

    [[AccountManager SharedInstance] setAndSaveUsername:self.userName];
#warning self.passWord注册后设置密码还没有获得
    [[AccountManager SharedInstance] setAndSavePassword:self.passWord];
    [[AccountManager SharedInstance] setAndUid:uid
                                     accesskey:accessKey
                                         pbkey:pbKey];
    
    //上传位置信息
    [[MyNetManager SharedInstance] reqestUploadLocationLat:[AccountManager SharedInstance].latitude longitude:[AccountManager SharedInstance].longitude];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginSuccess)]) {
        [self.navigationController popViewControllerAnimated:NO];
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginSuccess)]) {
            [self.delegate loginSuccess];
        }
    }
}

- (void)rsaAcc:(NSString *)acckey pbKey:(NSString *)pbkey
{
    RSA *rsa = [RSA shareInstance];
    [rsa generateKeyPairRSACompleteBlock:^{
        if (acckey) {
            //encrypt
            NSData *encryptData = [acckey dataUsingEncoding:NSUTF8StringEncoding];
            
            //decrypt
            NSData *decryptData = [rsa RSA_DecryptUsingPublicKeyWithData:encryptData];
            NSString *newAcckey = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
            
            NSLog(@"newAcckey==%@", newAcckey);
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
