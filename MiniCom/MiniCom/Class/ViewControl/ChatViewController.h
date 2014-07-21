//
//  ChatViewController.h
//  MiniCom
//
//  Created by wlp on 14-6-10.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupNavView.h"
#import "GroupDetailView.h"
#import "EmojiView.h"
@class AccountData;
@class GroupData;
@class HPGrowingTextView;
@class JXEmoji;

//typedef enum{
//    /**
//     * 单聊
//     */
//	ENUM_ChatType_Friend	 = 100,
//    /**
//     * 群聊
//     */
//	ENUM_ChatType_Group      = 101,
//    
//}ENUM_ChatType;

@interface ChatViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    GroupNavView *_navView;
    UITableView *_chatTableView;
    
    UIView *_mediaInputView;

    UIView *_inputView;
    UITextView *_textView;
    JXEmoji *_messageConent;
    
    EmojiView* _faceView;
}

//@property(nonatomic, assign) ENUM_ChatType chatType;

@property(nonatomic, retain) NSString *myPhone;

@property(nonatomic, retain) NSString *sendType;

@property(nonatomic, retain) AccountData *myAccount;

@property(nonatomic, retain) AccountData *friendAccount;

@property(nonatomic, retain) GroupData *groupData;

@property(nonatomic, retain) NSMutableArray *memberAry;

@property(nonatomic, retain) NSMutableArray *chatAry;


- (void)updateChatView;

@end
