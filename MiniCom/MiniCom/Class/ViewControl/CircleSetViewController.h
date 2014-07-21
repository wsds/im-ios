//
//  CircleSetViewController.h
//  MiniCom
//
//  Created by wlp on 14-7-4.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainViewController;
@class GroupMemberSelectView;
@class CircleData;
@class AccountData;

@interface CircleSetViewController : UIViewController
{
    UIScrollView *_myCircleView;
    
    GroupMemberSelectView *_memberSelectView;
    
    UIView *_contrlView;
}

@property (nonatomic, assign)   MainViewController *mainVCdelegate;

@property (nonatomic, assign)   int page;

@property (nonatomic, retain)   NSMutableArray *myCircleAry;

@property (nonatomic, retain)   CircleData *curCircle;

@property (nonatomic, retain)   NSMutableArray *selectedFriendsAry;

@property (nonatomic, retain)   AccountData *curAccount;

@end
