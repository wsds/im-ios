//
//  Login_normalView.m
//  MiniCom
//
//  Created by wlp on 14-5-18.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "Login_normalView.h"
#import "LoginViewController.h"


@implementation Login_normalView

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
        _username_tf = [[UITextField alloc] initWithFrame:[Common RectMakex:0 y:0 w:1.0 h:0.22 onSuperBounds:self.contentView.bounds]];
        _username_tf.contentVerticalAlignment =  UIControlContentVerticalAlignmentCenter;
        _username_tf.borderStyle = UITextBorderStyleNone;
        _username_tf.textAlignment = NSTextAlignmentLeft;
        _username_tf.placeholder = @"请输入手机号";
        _username_tf.delegate = self;
        _username_tf.returnKeyType = UIReturnKeyDone;
        _username_tf.keyboardType = UIKeyboardTypeNumberPad;
        _username_tf.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_username_tf];
        
        //密码
        _password_tf = [[UITextField alloc] initWithFrame:[Common RectMakex:0 y:0.22 w:1.0 h:0.22 onSuperBounds:self.contentView.bounds]];
        _password_tf.contentVerticalAlignment =  UIControlContentVerticalAlignmentCenter;
        _password_tf.borderStyle = UITextBorderStyleNone;
        _password_tf.textAlignment = NSTextAlignmentLeft;
        _password_tf.placeholder = @"请输入密码";
        _password_tf.delegate = self;
        _password_tf.returnKeyType = UIReturnKeyDone;
        [_password_tf setSecureTextEntry:YES];
        _password_tf.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_password_tf];
        
        //登陆按钮
        _login_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _login_btn.frame = [Common RectMakex:0 y:0.45 w:1.0 h:0.2 onSuperBounds:self.contentView.bounds];
        [_login_btn setBackgroundImage:[UIImage imageNamed:@"button_background_normal.png"] forState:UIControlStateNormal];
//        [_login_btn setBackgroundImage:[UIImage imageNamed:@"dengluanxia.png"] forState:UIControlStateHighlighted];
        [_login_btn setTitle:@"登录" forState:UIControlStateNormal];
        [_login_btn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView  addSubview:_login_btn];
        
        //register
        _register_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _register_btn.frame = [Common RectMakex:0 y:0.67 w:1.0 h:0.2 onSuperBounds:self.contentView.bounds];
        [_register_btn setBackgroundImage:[UIImage imageNamed:@"button_background_normal.png"] forState:UIControlStateNormal];
//        [_register_btn setBackgroundImage:[UIImage imageNamed:@"zuceanxia.png"] forState:UIControlStateHighlighted];
        [_register_btn setTitle:@"没有账号/注册" forState:UIControlStateNormal];
        [_register_btn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView  addSubview:_register_btn];

        //codelogin
        _codeLogin_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _codeLogin_btn.frame = [Common RectMakex:0.65 y:0.88 w:0.35 h:0.12 onSuperBounds:self.contentView.bounds];
        [_codeLogin_btn setTitle:@"验证码登录" forState:UIControlStateNormal];
        [_codeLogin_btn.titleLabel setFont:[UIFont systemFontOfSize:[Common getCurFontSize:BaseFontSize_L]]];
        [_codeLogin_btn addTarget:self action:@selector(codeLoginAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView  addSubview:_codeLogin_btn];
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

- (void)loginAction
{
    if ([_username_tf.text length] <= 0) {
        [Common alert4error:CheckUserName_Null tag:0 delegate:nil];
        return;
    }
    if ([_password_tf.text length] <= 0) {
        [Common alert4error:CheckPassword_Null tag:0 delegate:nil];
        return;
    }
    if ([_username_tf.text isUserName]) {
        //login
        [_object loginWithUsername:_username_tf.text
                          password:_password_tf.text];
    }
    else
    {
        [Common alert4error:CheckUserName_Fail tag:0 delegate:nil];
    }
}

- (void)registerAction
{
    [_object registerAction];
}

- (void)codeLoginAction
{
    [_object codeLoginAction];
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
