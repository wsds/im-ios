//
//  GroupMemberSelectView.m
//  MiniCom
//
//  Created by wlp on 14-6-29.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "GroupMemberSelectView.h"
#import "AccountData.h"
#import "Header.h"
#import "IconView.h"

@implementation GroupMemberSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self loadSelectedFriendsView];
        
        [self loadNavContrlView];
    }
    return self;
}

- (void)loadSelectedFriendsView
{
    _selectedFrindView = [[UIView alloc] initWithFrame:[Common RectMakex:0 y:0.0 w:1.0 h:0.5 onSuperBounds:self.bounds]];
    [self addSubview:_selectedFrindView];
    
    [Common addImageName:@"button_background_click.png" onView:_selectedFrindView frame:_selectedFrindView.bounds];
    
    //line
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _selectedFrindView.frame.size.height - 1.0, _selectedFrindView.frame.size.width, 1.0)];
    lineView.backgroundColor = [UIColor whiteColor];
    [_selectedFrindView addSubview:lineView];
    
    _friendsScrollView = [[UIScrollView alloc] initWithFrame:_selectedFrindView.bounds];
    [_selectedFrindView addSubview:_friendsScrollView];
}

- (void)loadNavContrlView
{
    _navControlView = [[UIView alloc] initWithFrame:[Common RectMakex:0 y:0.5 w:1.0 h:0.5 onSuperBounds:self.bounds]];
    [self addSubview:_navControlView];
    
    [Common addImageName:@"button_background_click.png" onView:_navControlView frame:_navControlView.bounds];
    
    float hhh = 0.7;
    float xOffset = 20.0;
    float imgwh = _navControlView.bounds.size.height * hhh;
    
    //left
    CGRect btnFrame1 = CGRectMake(xOffset, 0, imgwh, imgwh);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = btnFrame1;
    [btn setBackgroundImage:[UIImage imageNamed:@"circlemenu_item2_4.png"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.bounds.size.height, 0, -_navControlView.bounds.size.height * (0.85 - hhh), 0)];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:[Common getCurFontSize:BaseFontSize_S]]];
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [_navControlView addSubview:btn];
    
    //right
    float x = _navControlView.bounds.size.width - imgwh - xOffset;
    CGRect btnFrame2 = CGRectMake(x, 0, imgwh, imgwh);
    UIButton *rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rbtn.frame = btnFrame2;
    [rbtn setBackgroundImage:[UIImage imageNamed:@"btn_setting_normal.png"] forState:UIControlStateNormal];
    [rbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [rbtn setTitle:@"下一步" forState:UIControlStateNormal];
    [rbtn setTitleEdgeInsets:UIEdgeInsetsMake(btn.bounds.size.height, 0, -_navControlView.bounds.size.height * (0.85 - hhh), 0)];
    [rbtn.titleLabel setFont:[UIFont systemFontOfSize:[Common getCurFontSize:BaseFontSize_S]]];
    [rbtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [_navControlView addSubview:rbtn];
}

- (void)backAction
{
    [self.delegate cancelAction];
}

- (void)doneAction
{
    [self.delegate doneAction];
}

- (void)setControlShow:(BOOL)show
{
    _navControlView.hidden = !show;
}

- (void)updateWithMembers:(NSArray *)friends
{
    for (UIView *view in [_friendsScrollView subviews]) {
        [view removeFromSuperview];
    }
    self.memberAry = friends;
    if (friends && [friends count] > 0) {
        int count = [friends count];
        float hhh = 0.9;
        float wh = _friendsScrollView.bounds.size.height * hhh;
        float y = (_friendsScrollView.bounds.size.height - wh) / 2;
        CGSize size = CGSizeMake(wh * count, wh);
        _friendsScrollView.contentSize = size;
        
        for (int i = 0; i < count; i++) {
            
            AccountData *acc = [friends objectAtIndex:i];
            
            CGRect frame = CGRectMake(wh * i, y, wh, wh);
            
            IconView *icon = [[IconView alloc] initWithFrame:frame image:acc.head title:acc.nickName];
            [icon addTarget:self action:@selector(memberBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            icon.tag = i;
            [_friendsScrollView addSubview:icon];
        }
    }
}

- (void)memberBtnAction:(id)sender
{
    IconView *btn = (IconView *)sender;
    AccountData *acc = [self.memberAry objectAtIndex:btn.tag];
    
    [self.delegate selectMember:acc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
