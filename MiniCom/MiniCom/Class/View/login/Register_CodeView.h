//
//  Register_CodeView.h
//  MiniCom
//
//  Created by wlp on 14-5-18.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "BaseTitleView.h"

@interface Register_CodeView : BaseTitleView
{
    UILabel *_mess_lb;
    UITextField *_code_tf;
    UIButton *_sendCode_btn;
}

@property(nonatomic, retain) NSString *registerPhone;

@property (retain, nonatomic) NSTimer *timer;
@property (assign, nonatomic) int times;
@property (assign, nonatomic) BOOL isTiming;

- (void)setPhone:(NSString *)phone;

- (void)startSendCodeTimer;
- (void)stopTimer;

@end
