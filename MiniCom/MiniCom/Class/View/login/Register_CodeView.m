//
//  Register_CodeView.m
//  MiniCom
//
//  Created by wlp on 14-5-18.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "Register_CodeView.h"
#import "LoginViewController.h"

#define maxTime 60
#define SendCode @"发送验证码"

@implementation Register_CodeView

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
        
        _mess_lb = [[UILabel alloc] init];
        _mess_lb.frame = [Common RectMakex:0 y:0.0 w:1.0 h:0.2 onSuperBounds:self.contentView.bounds];
        _mess_lb.textColor = [UIColor whiteColor];
        [_mess_lb setFont:[UIFont systemFontOfSize:[Common getCurFontSize:BaseFontSize_M]]];
        [self.contentView addSubview:_mess_lb];

        //验证码
        _code_tf = [[UITextField alloc] initWithFrame:[Common RectMakex:0 y:0.2 w:1.0 h:0.3 onSuperBounds:self.contentView.bounds]];
        _code_tf.contentVerticalAlignment =  UIControlContentVerticalAlignmentCenter;
        _code_tf.borderStyle = UITextBorderStyleNone;
        _code_tf.textAlignment = NSTextAlignmentLeft;
        _code_tf.placeholder = @"请输入验证码";
        _code_tf.delegate = self;
        _code_tf.returnKeyType = UIReturnKeyDone;
        //[_code_tf setSecureTextEntry:YES];
        _code_tf.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_code_tf];
        
        //next
        UIButton *next_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        next_btn.frame = [Common RectMakex:0.0 y:0.52 w:1.0 h:0.28 onSuperBounds:self.contentView.bounds];
        [next_btn setBackgroundImage:[UIImage imageNamed:@"button_background_normal.png"] forState:UIControlStateNormal];
        [next_btn setTitle:@"下一步" forState:UIControlStateNormal];
        [next_btn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView  addSubview:next_btn];
        
        //sendcode
        _sendCode_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendCode_btn.frame = [Common RectMakex:0.65 y:0.8 w:0.35 h:0.2 onSuperBounds:self.contentView.bounds];
        [_sendCode_btn setTitle:SendCode forState:UIControlStateNormal];
        [_sendCode_btn.titleLabel setFont:[UIFont systemFontOfSize:[Common getCurFontSize:BaseFontSize_M]]];
        [_sendCode_btn addTarget:self action:@selector(sendCodeAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView  addSubview:_sendCode_btn];
    }
    return self;
}

- (void)show
{
    [_code_tf becomeFirstResponder];
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

- (void)setPhone:(NSString *)phone
{
    self.registerPhone = phone;
    _mess_lb.text = [NSString stringWithFormat:@"我们已将短信发送到%@", self.registerPhone];
}

- (void)sendCodeAction
{
    NSLog(@"reg sendCodeAction");
    [_object sendCodeToPhone:self.registerPhone usage:@"register"];
}

- (void)nextAction
{
    if ([_code_tf.text length] > 0) {
        [_object loginWithUsername:self.registerPhone code:_code_tf.text fromRegister:YES];
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
