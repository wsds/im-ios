//
//  NewFriendCell.h
//  MiniCom
//
//  Created by wlp on 14-6-22.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AccountData;

@protocol friendTableViewCellDelegate <NSObject>

- (void)selectMember:(AccountData *)account status:(BOOL)status;

@end

@interface NewFriendCell : UITableViewCell
{
    UIView *_disView;
    UIImageView *_bgImageView;
    
    UIView *_contentView;
    UIImageView *_iconImageView;
    
    UILabel *_nameLabel;
    UILabel *_contentLabel;
    
    UIButton *_agreeBtn;
    UIButton *_rejectBtn;
}
@property (nonatomic, assign) id <friendTableViewCellDelegate>delegate;

@property (nonatomic, retain) AccountData *friendData;

- (void)setCellWithData:(AccountData *)data;

@end
