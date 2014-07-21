//
//  MyInfoViewController.h
//  MiniCom
//
//  Created by wlp on 14-5-24.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountData.h"
@class MainViewController;
@class UserInfoView;
@class TwoDCodeView;

@interface MyInfoViewController : UIViewController
{
    UIImageView *_bgImageView;
    
    UIScrollView *_scrollv;
    
    UserInfoView *_userInfoView;
    TwoDCodeView *_twoDCodeView;
}

@property (nonatomic, retain) AccountData *account;

@property (nonatomic, assign) MainViewController *mainVCdelegate;

@property (nonatomic, retain) NSString *imageFileName;

@end
