//
//  GroupMemberSelectView.h
//  MiniCom
//
//  Created by wlp on 14-6-29.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AccountData;

@protocol GroupMemberSelectViewDelegate <NSObject>

- (void)selectMember:(AccountData *)account;

- (void)cancelAction;

- (void)doneAction;

@end

@interface GroupMemberSelectView : UIView
{
    UIView *_selectedFrindView;
    UIScrollView *_friendsScrollView;
    
    UIView *_navControlView;
}

@property (nonatomic, assign) id<GroupMemberSelectViewDelegate> delegate;

@property (nonatomic, retain) NSArray *memberAry;

- (void)setControlShow:(BOOL)show;

- (void)updateWithMembers:(NSArray *)ary;

@end
