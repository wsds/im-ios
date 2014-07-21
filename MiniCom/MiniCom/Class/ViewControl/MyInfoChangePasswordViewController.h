//
//  MyInfoChangePasswordViewController.h
//  MiniCom
//
//  Created by wlp on 14-6-4.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SaveAccountCtrView;

@interface MyInfoChangePasswordViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSArray *_cellText_Ary;
    
    UIButton *_bgBtn;
    
    UIView *_infoView;
    CGRect _okFrame;
    CGRect _upFrame;
    
    UITextField *_oldPassword_tf;
    UITextField *_newPassword_tf;
    UITextField *_renewPassword_tf;
    
    SaveAccountCtrView *_ctrView;
}

@property(nonatomic, retain) NSString *passwordNew;

@end
