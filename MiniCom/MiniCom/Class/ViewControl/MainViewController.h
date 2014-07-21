//
//  MainViewController.h
//  LittleWeather
//
//  Created by wlp on 14-4-20.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopItemsView.h"

#import "SquareView.h"

#import "GroupBaseView.h"
#import "GroupOurs.h"
#import "GroupNear.h"

#import "OwnFriendView.h"
#import "OwnMessageView.h"

@protocol LoadingDelegate;
@protocol TopItemsViewBtnSelectDelegate;
@protocol GroupOursDelegate;
@protocol GroupNearDelegate;
@protocol OwnMessageViewDelegate;


@interface MainViewController : UIViewController<UIScrollViewDelegate,
                                                LoadingDelegate,
                                                TopItemsViewBtnSelectDelegate,
                                                GroupOursDelegate,
                                                GroupNearDelegate,
                                                OwnFriendViewDelegate,
                                                OwnMessageViewDelegate>
{
    NSMutableArray *_viewAry;
    
    UILabel *label;
    
    TopItemsView *_itemsView;
    
    UIView *_contentView;
    
    SquareView *_squareView;
    
    GroupOurs *_myGroupView;
    GroupNear *_nearGroupView;
    
    OwnFriendView *_myFriendsView;
    OwnMessageView *_myMessageView;
}

@property(retain, nonatomic)NSString *cityCode;

//net request
- (void)getGroupsAndMembers;
- (void)getNearGroups;

- (void)getCirclesAndFriends;

- (void)presentLoginVC;

@end
