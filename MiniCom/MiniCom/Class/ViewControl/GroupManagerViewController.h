//
//  GroupManagerViewController.h
//  MiniCom
//
//  Created by wlp on 14-6-10.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MoreAccountView;
@class GroupMemberSelectView;
@class GroupData;

@protocol MoreAccountViewDelegate;
@protocol GroupMemberSelectViewDelegate;
@protocol MyHttpDelegate;

@interface GroupManagerViewController : UIViewController<MoreAccountViewDelegate, GroupMemberSelectViewDelegate, MyHttpDelegate>
{
    MoreAccountView *_curGroupAccountView;
    
    GroupMemberSelectView *_memberSelectView;
    UIView *_contrlView;
}

@property(nonatomic, retain) GroupData *groupData;

@property(nonatomic, retain) NSMutableArray *curGroupMembersAry;

@property(nonatomic, retain) NSMutableArray *tempGroupMembersAry;

@property (nonatomic, retain)NSMutableArray *selectedFriendsAry;

@end
