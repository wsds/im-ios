//
//  MyInfoChangeViewController.h
//  MiniCom
//
//  Created by wlp on 14-5-26.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SaveAccountCtrView;
@class PhotoControlView;
@class AccountData;

@protocol SaveAccountCtrViewDelegate;
@protocol MyHttpDelegate;

@interface MyInfoChangeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, SaveAccountCtrViewDelegate, MyHttpDelegate>
{
    NSArray *_cellText_Ary;
    
    UIButton *_bgBtn;
    
    UIView *_infoView;
    CGRect _okFrame;
    CGRect _upFrame;
    
    UIButton *_changePass_btn;
    UIImageView *_icon_imgV;
    UITextField *_username_tf;
    UILabel *_sex_lb;
    UITextField *_phone_tf;
    UITextView *_buss_tv;
    
    SaveAccountCtrView *_ctrView;
    PhotoControlView *_photoControlView;
}

@property (nonatomic, retain) AccountData *account;

@property (nonatomic, assign) BOOL isIconChange;

@end
