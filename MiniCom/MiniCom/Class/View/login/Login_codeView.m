//
//  Login_codeView.m
//  MiniCom
//
//  Created by wlp on 14-5-18.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "Login_codeView.h"
#import "LoginViewController.h"

#define maxTime 60
#define SendCode @"发送验证码"

@implementation Login_codeView

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
           needBack:(BOOL)needBack
           delegate:(id)delegate
                tag:(int)tag
{
    self = [super initWithFrame:(CGRect)frame
                          title:(NSString *)title
                       needBack:(BOOL)needBack
                       delegate:(id)delegate
                            tag:(int)tag];
    if (self) {
        // Initialization code
        _object = (LoginViewController *)self.delegate;
        
        //用户名
        _username_tf = [[UITextField alloc] initWithFrame:[Common RectMakex:0 y:0 w:1.0 h:0.3 onSuperBounds:self.contentView.bounds]];
        _username_tf.contentVerticalAlignment =  UIControlContentVerticalAlignmentCenter;
        _username_tf.borderStyle = UITextBorderStyleNone;
        _username_tf.textAlignment = NSTextAlignmentLeft;
        _username_tf.placeholder = @"请输入手机号";
        _username_tf.delegate = self;
        _username_tf.returnKeyType = UIReturnKeyDone;
        _username_tf.keyboardType = UIKeyboardTypeNumberPad;
        _username_tf.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_username_tf];
        
        //验证码
        _code_tf = [[UITextField alloc] initWithFrame:[Common RectMakex:0 y:0.3 w:1.0 h:0.3 onSuperBounds:self.contentView.bounds]];
        _code_tf.contentVerticalAlignment =  UIControlContentVerticalAlignmentCenter;
        _code_tf.borderStyle = UITextBorderStyleNone;
        _code_tf.textAlignment = NSTextAlignmentLeft;
        _code_tf.placeholder = @"请输入验证码";
        _code_tf.delegate = self;
        _code_tf.returnKeyType = UIReturnKeyDone;
        //[_code_tf setSecureTextEntry:YES];
        _code_tf.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_code_tf];
        
        //登陆按钮
        _login_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _login_btn.frame = [Common RectMakex:0 y:0.6 w:1.0 h:0.25 onSuperBounds:self.contentView.bounds];
        [_login_btn setBackgroundImage:[UIImage imageNamed:@"button_background_normal.png"] forState:UIControlStateNormal];
        //        [_login_btn setBackgroundImage:[UIImage imageNamed:@"dengluanxia.png"] forState:UIControlStateHighlighted];
        [_login_btn setTitle:@"登录" forState:UIControlStateNormal];
        [_login_btn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView  addSubview:_login_btn];
        
        //sendcode
        _sendCode_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendCode_btn.frame = [Common RectMakex:0.65 y:0.85 w:0.35 h:0.15 onSuperBounds:self.contentView.bounds];
        [_sendCode_btn setTitle:SendCode forState:UIControlStateNormal];
        [_sendCode_btn.titleLabel setFont:[UIFont systemFontOfSize:[Common getCurFontSize:BaseFontSize_L]]];
        [_sendCode_btn addTarget:self action:@selector(sendCodeAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView  addSubview:_sendCode_btn];
    }
    return self;
}

- (void)show
{
    [_username_tf becomeFirstResponder];
}

- (void)hide
{
}

- (void)backAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(baseViewBack:)]) {
        [self.delegate baseViewBack:self.myTag];
    }
}

- (void)loginAction
{
    if ([_username_tf.text length] <= 0) {
        [Common alert4error:CheckUserName_Null tag:0 delegate:nil];
        return;
    }
    if ([_code_tf.text length] <= 0) {
        [Common alert4error:CheckCode_Null tag:0 delegate:nil];
        return;
    }
    if ([_username_tf.text isUserName]) {
        //login
        [_object loginWithUsername:_username_tf.text
                              code:_code_tf.text
                      fromRegister:NO];
    }
    else
    {
        [Common alert4error:CheckUserName_Fail tag:0 delegate:nil];
    }
}

- (void)sendCodeAction
{
    NSLog(@"login sendCodeAction");
    if ([_username_tf.text isUserName]) {
        [_object sendCodeToPhone:_username_tf.text usage:@"login"];
    }
    else
    {
        [Common alert4error:CheckUserName_Fail tag:0 delegate:nil];
    }
}

#pragma mark timer

- (void)startSendCodeTimer
{
    [self stopTimer];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeUpdate) userInfo:nil repeats:YES];
    
    _times = 0;
    _isTiming = YES;
    _sendCode_btn.enabled = NO;
}

- (void)stopTimer
{
    if (_timer) {
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

- (void)timeUpdate
{
    _times++;
    if (_times == maxTime) {

        _isTiming = NO;
        _sendCode_btn.enabled = YES;
        [_sendCode_btn setTitle:SendCode forState:UIControlStateNormal];

        [self stopTimer];
    }
    else
    {
        [_sendCode_btn setTitle:[NSString stringWithFormat:@"重新发送(%d)", maxTime - _times] forState:UIControlStateDisabled];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
