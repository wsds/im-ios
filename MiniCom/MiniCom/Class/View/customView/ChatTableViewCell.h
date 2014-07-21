//
//  ChatTableViewCell.h
//  MiniCom
//
//  Created by wlp on 14-6-16.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessData.h"
#import "AccountData.h"
@class VoicePlayAnimationView;
@class SCGIFImageView;
@class JXEmoji;

#define JXCELL_W 244
#define JXCELL_H 68

@protocol ChatTableViewCellDelegate <NSObject>

- (void)selectChatMember:(AccountData *)account;

@end

@interface ChatTableViewCell : UITableViewCell
{
    UIView *_disView;
    UIImageView *_bgImageView;
    
    UIImageView *_icon_left;
    UIImageView *_icon_right;
    
    UIButton *_iconBtn_left;
    UIButton *_iconBtn_right;

    CGRect iconFrame_L;
    CGRect iconFrame_R;
    
    UIView *_contentView;
    CGRect contentFrame_L;
    CGRect contentFrame_R;
    
    JXEmoji *_messageConent;
    //UITextView *_contentTextView;
    UIImageView *_contentImageView;
    VoicePlayAnimationView *_contentVoiceView;
    UIView *_gifView;
    SCGIFImageView* _gifv;
}

@property (nonatomic, assign) id <ChatTableViewCellDelegate>delegate;

@property (nonatomic, retain) AccountData *mineData;

@property (nonatomic, retain) AccountData *friendData;

- (void)setCellWithData:(ChatMessData *)data;

@end
