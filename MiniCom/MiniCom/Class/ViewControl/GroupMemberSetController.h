//
//  GroupAddViewController.h
//  MiniCom
//
//  Created by wlp on 14-6-10.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MoreAccountView;
@class GroupMemberSelectView;
@class GroupData;

typedef enum{
    ENUM_GROUP_Type_New,
    ENUM_GROUP_Type_Add,
    ENUM_GROUP_Type_Change,
}ENUM_GROUP_MANAGER_Type;

@interface GroupMemberSetController : UIViewController
{
    UIScrollView *_myCircleView;
    
    GroupMemberSelectView *_memberSelectView;
}

@property (nonatomic, assign)ENUM_GROUP_MANAGER_Type groupManagerType;

@property (nonatomic, retain)NSMutableArray *myCircleAry;

@property (nonatomic, retain)GroupData *curGroup;

@property (nonatomic, retain)NSMutableArray *selectedFriendsAry;

@end
