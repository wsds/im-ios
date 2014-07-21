//
//  OwnMyFriendView.m
//  MiniCom
//
//  Created by wlp on 14-5-24.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "OwnFriendView.h"
#import "Common.h"
#import "AccountManager.h"
#import "UIButton+WebCache.h"
#import "MBProgressHUD.h"
#import "AnalyTools.h"
#import "MoreAccountView.h"
#import "CircleData.h"

@implementation OwnFriendView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _ScrollV = [[UIScrollView alloc] initWithFrame:self.bounds];
        _ScrollV.showsVerticalScrollIndicator = NO;
        [self addSubview:_ScrollV];
        
        _newFriend_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _newFriend_btn.frame = [Common RectMakex:0.0 y:0.0 w:1.0 h:0.1 onSuperBounds:_ScrollV.bounds];
        [_newFriend_btn setBackgroundImage:[UIImage imageNamed:@"button_background_click.png"] forState:UIControlStateNormal];
        [_newFriend_btn addTarget:self action:@selector(newFriendsAction) forControlEvents:UIControlEventTouchUpInside];
        [_ScrollV addSubview:_newFriend_btn];
        
        _circleView = [[UIView alloc] init];
        _circleView.frame = CGRectMake(0, _newFriend_btn.frame.origin.y + _newFriend_btn.frame.size.height + 5, _ScrollV.bounds.size.width, 0);
        [_ScrollV addSubview:_circleView];
        
        _moreFriend_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreFriend_btn.frame = CGRectMake(0, _circleView.frame.origin.y + _circleView.frame.size.height, _ScrollV.bounds.size.width, 44);
        [_moreFriend_btn setBackgroundImage:[UIImage imageNamed:@"button_background_click.png"] forState:UIControlStateNormal];
        [_moreFriend_btn setTitle:@"找到更多的密友" forState:UIControlStateNormal];
        [_moreFriend_btn addTarget:self action:@selector(moreFriendsAction) forControlEvents:UIControlEventTouchUpInside];
        [_ScrollV addSubview:_moreFriend_btn];
        
        _ScrollV.contentSize = CGSizeMake(_ScrollV.bounds.size.width, _moreFriend_btn.frame.origin.y + _moreFriend_btn.frame.size.height + 10);
        
#warning temp need use shareLongSessionData
        [self updateNewFriendAry:nil];
    }
    return self;
}

- (void)updateNewFriendAry:(NSArray *)ary
{
    self.frindsAgreeAry = ary;
    
    if (ary && [ary count] > 0) {
        NSString *title = [NSString stringWithFormat:@"新的好友(%d)", [ary count]];
        [_newFriend_btn setTitle:title forState:UIControlStateNormal];
        _newFriend_btn.hidden = NO;

    }
    else{
        _newFriend_btn.hidden = YES;
    }
}

- (void)newFriendsAction
{
    [self.delegate showNewFriend:self.frindsAgreeAry];
}

- (void)moreFriendsAction
{
    [self.delegate moreFriend];
}

- (void)updateWithCircleAry:(NSArray *)ary
{
    for (UIView *view in _circleView.subviews) {
        [view removeFromSuperview];
    }
    float wAndh = _circleView.bounds.size.width;
    float yOffset = 10.0;
    
    for (int i=0; i<[ary count]; i++) {
        CircleData *circle = [ary objectAtIndex:i];

        CGRect circleFrame = CGRectMake(0, (wAndh + yOffset) * i, wAndh, wAndh);
        MoreAccountView *subCircleView = [[MoreAccountView alloc] initWithFrame:circleFrame title:circle.name needBack:NO delegate:self tag:i];
        subCircleView.accountListDelegate = self;
        subCircleView.longPressEnable = YES;
        [_circleView addSubview:subCircleView];
        [subCircleView updateAccountWithAry:circle.accounts];
    }
    
    //set frame
    _circleView.frame = CGRectMake(_circleView.frame.origin.x,
                                   _circleView.frame.origin.y,
                                   _circleView.frame.size.width,
                                   (wAndh + yOffset) * [ary count]);
    _moreFriend_btn.frame = CGRectMake(0, _circleView.frame.origin.y + _circleView.frame.size.height, _moreFriend_btn.bounds.size.width, 40);
    _ScrollV.contentSize = CGSizeMake(_ScrollV.bounds.size.width, _moreFriend_btn.frame.origin.y + _moreFriend_btn.frame.size.height + 10);
}

- (void)selectAccount:(AccountData *)account;
{
    [self.delegate showChatViewFriend:account];
}

- (void)longPressAction:(int)tag
{
    NSLog(@"longPressAction tag==%d", tag);
    [self.delegate showCircleSetViewPage:tag];
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
