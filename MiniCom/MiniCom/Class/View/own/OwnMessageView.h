//
//  OwnMessageView.h
//  MiniCom
//
//  Created by wlp on 14-5-24.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AccountData;

@protocol OwnMessageViewDelegate <NSObject>

- (void)showChatViewFriend:(AccountData *)friendAccount;

- (void)showChatViewGroup:(NSString *)gid;

@end

@interface OwnMessageView : UIView
{
    UITableView *_chatTableView;
    
    UIImageView *_noChatBg;
}
@property(assign, nonatomic) id <OwnMessageViewDelegate>delegate;

@property (nonatomic, retain) NSMutableArray *chatAry;

- (void)updateChatTable;

@end
