//
//  Login_codeView.h
//  MiniCom
//
//  Created by wlp on 14-5-18.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "BaseTitleView.h"

@interface Login_codeView : BaseTitleView
{
    UITextField *_username_tf;
    UITextField *_code_tf;
    
    UIButton *_login_btn;
    UIButton *_sendCode_btn;
}

@property (retain, nonatomic) NSTimer *timer;
@property (assign, nonatomic) int times;
@property (assign, nonatomic) BOOL isTiming;

- (void)startSendCodeTimer;
- (void)stopTimer;

@end
