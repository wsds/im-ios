//
//  LoginViewController.h
//  MiniCom
//
//  Created by wlp on 14-5-18.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Login_normalView;
@class Login_codeView;
@class Register_UserView;
@class Register_CodeView;
@class Register_PasswordView;

enum{
    ENUM_LOGIN_VIEW_NORMAL,
    ENUM_LOGIN_VIEW_CODE,
    ENUM_REG_VIEW_USER,
    ENUM_REG_VIEW_CODE,
    ENUM_REG_VIEW_PASSWORD
};

@protocol LoginDelegate <NSObject>

- (void)loginSuccess;

@end

@protocol MyHttpDelegate;

@interface LoginViewController : UIViewController<MyHttpDelegate>
{  
    Login_normalView        *_login_normalView;
    Login_codeView          *_login_codeView;
    Register_UserView       *_reg_userView;
    Register_CodeView       *_reg_codeView;
    Register_PasswordView   *_reg_passwordView;
    
    CGRect showFrame1;
    CGRect showFrame2;
    CGRect showFrame3;
    CGRect showFrame4;
    CGRect showFrame5;
}

@property (assign, nonatomic) id <LoginDelegate>delegate;

@property (retain ,nonatomic) NSString *userName;
@property (retain ,nonatomic) NSString *passWord;

- (void)registerAction;

- (void)codeLoginAction;

- (void)nextBtnCallback:(int)tag;

- (void)showViewTag:(int)tag
          animation:(BOOL)animation
               isUp:(BOOL)isUp;

- (void)hideViewTag:(int)tag
          animation:(BOOL)animation
               isUp:(BOOL)isUp;

//
- (void)loginWithUsername:(NSString *)username password:(NSString *)password;

- (void)loginWithUsername:(NSString *)username
                     code:(NSString *)password
             fromRegister:(BOOL)isNewRegister;

- (void)sendCodeToPhone:(NSString *)phone usage:(NSString *)usage;

- (void)changePasswordRequestOldPass:(NSString *)oldPass newPass:(NSString *)newPass;

@end
