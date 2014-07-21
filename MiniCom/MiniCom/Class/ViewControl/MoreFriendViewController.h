//
//  MoreFriendViewController.h
//  MiniCom
//
//  Created by wlp on 14-6-16.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreAccountView.h"
#import "BaseTitleView.h"

@interface MoreFriendViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate, MoreAccountViewDelegate, MyHttpDelegate>
{
    UIScrollView *_scrollv;
    CGRect _okFrame;
    CGRect _upFrame;
    
    MoreAccountView *_moreFriendView;
    
    BaseTitleView *_findFriendView;
    UITextField *_username_tf;
    
    int _aryCount;
}

@end
