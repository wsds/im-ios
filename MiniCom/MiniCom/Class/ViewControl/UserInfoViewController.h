//
//  UserInfoViewController.h
//  MiniCom
//
//  Created by wlp on 14-6-17.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountData.h"
@class GroupListView;

@interface UserInfoViewController : UIViewController
{
    UIScrollView *_scrollv;
    
    GroupListView *_userGroupView;
    
    BOOL _isFriend;
}

@property (nonatomic, retain) AccountData *account;

@end
