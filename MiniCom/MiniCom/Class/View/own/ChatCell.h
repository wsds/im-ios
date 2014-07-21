//
//  ChatCell.h
//  MiniCom
//
//  Created by wlp on 14-6-16.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessData.h"
#import "AccountData.h"
@class NumView;

//我的消息cell

@interface ChatCell : UITableViewCell
{
    UIView *_disView;
    UIImageView *_bgImageView;
    
    UIView *_contentView;
    UIImageView *_iconImageView;

    UILabel *_nameLabel;
    UILabel *_contentLabel;
    
    NumView *_unReadCountView;
}

@property (nonatomic, retain) AccountData *friendData;

- (void)setCellWithData:(ChatMessData *)data;

- (void)setUnreadCount:(int)num;

@end
