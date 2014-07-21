//
//  GroupSubView.h
//  MiniCom
//
//  Created by wlp on 14-6-28.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupData;

typedef enum
{
    ENUM_GROUP_SHOW,
    ENUM_GROUP_ADD
}ENUM_GROUP_TYPE;

@interface GroupSubView : UIView
{
    UIView *_contentView;
    
    UIView *_groupInfoView;
    UIView *_groupAddView;
    
    UILabel *_nameLb;
    UILabel *_countLb;
    UIView *_membersView;
    
    UILabel *_titleLb;
    
    UIButton *_viewBtn;
    
    ENUM_GROUP_TYPE _curType;
}

- (void)setType:(ENUM_GROUP_TYPE)type;

- (void)setAddTitle:(NSString *)title;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)updateWithGroupData:(GroupData *)groupData;

@end
