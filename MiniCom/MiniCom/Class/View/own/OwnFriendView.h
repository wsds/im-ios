//
//  OwnMyFriendView.h
//  MiniCom
//
//  Created by wlp on 14-5-24.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MoreAccountView;
@class AccountData;

@protocol OwnFriendViewDelegate <NSObject>

- (void)showNewFriend:(NSArray *)newFriendAry;

- (void)showChatViewFriend:(AccountData *)friendAccount;

- (void)showCircleSetViewPage:(int)page;

- (void)moreFriend;

@end

@interface OwnFriendView : UIView
{
    UIScrollView *_ScrollV;
        
    UIButton *_newFriend_btn;
    
    UIView *_circleView;

    UIButton *_moreFriend_btn;
}
@property(assign, nonatomic) id <OwnFriendViewDelegate>delegate;

@property(retain, nonatomic)NSArray *frindsAgreeAry;

- (void)updateNewFriendAry:(NSArray *)ary;

- (void)updateWithCircleAry:(NSArray *)ary;

@end
