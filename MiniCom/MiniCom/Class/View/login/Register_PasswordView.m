//
//  Register_PasswordView.m
//  MiniCom
//
//  Created by wlp on 14-5-18.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "Register_PasswordView.h"
#import "LoginViewController.h"
#import "NSString+Tools.h"

@implementation Register_PasswordView

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

        //密码
        _password_tf = [[UITextField alloc] initWithFrame:[Common RectMakex:0 y:0.1 w:1.0 h:0.4 onSuperBounds:self.contentView.bounds]];
        _password_tf.contentVerticalAlignment =  UIControlContentVerticalAlignmentCenter;
        _password_tf.borderStyle = UITextBorderStyleNone;
        _password_tf.textAlignment = NSTextAlignmentLeft;
        _password_tf.placeholder = @"请输入密码";
        _password_tf.delegate = self;
        _password_tf.returnKeyType = UIReturnKeyDone;
        [_password_tf setSecureTextEntry:YES];
        _password_tf.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_password_tf];
        
        //next
        UIButton *next_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        next_btn.frame = [Common RectMakex:0.0 y:0.55 w:1.0 h:0.35 onSuperBounds:self.contentView.bounds];
        [next_btn setBackgroundImage:[UIImage imageNamed:@"button_background_normal.png"] forState:UIControlStateNormal];
        [next_btn setTitle:@"下一步" forState:UIControlStateNormal];
        [next_btn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView  addSubview:next_btn];
    }
    return self;
}

- (void)show
{
    [_password_tf becomeFirstResponder];
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

- (void)nextAction
{
    if ([_password_tf.text isPassword]) {
        //[_object nextBtnCallback:self.myTag];
        [_object changePasswordRequestOldPass:@"" newPass:_password_tf.text];
    }
    else
    {
        [Common alert4error:CheckPassword_Fail tag:0 delegate:nil];
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
