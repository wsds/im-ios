//
//  BtnItemsView.m
//  MiniCom
//
//  Created by wlp on 14-5-21.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "TopItemsView.h"
#import "Common.h"
#import "MyButton.h"

enum{
    E_square,
    E_group,
    E_own
};

//#define baseH 0.6
//#define subH 1.0 - baseH

#define TopH 0.2
#define SubH (1.0 - TopH) / 2

@implementation TopItemsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self loadBaseView];
        
        [self loadSubView];
    }
    return self;
}

- (void)loadBaseView
{
    //self.backgroundColor = [UIColor darkGrayColor];

    _baseView = [[UIView alloc] initWithFrame:[Common RectMakex:0 y:TopH w:1.0 h:SubH onSuperBounds:self.bounds]];
    _baseView.backgroundColor = [UIColor colorWithRed:0.14 green:0.16 blue:0.26 alpha:1.0];
    [self addSubview:_baseView];
    
    
    _titleAry = @[@"广场", @"群组", @"我", @"广播"];
    float www = 1.0 / [_titleAry count];

    for (int i = 0; i < [_titleAry count]; i++) {
        MyButton *btn1 = [MyButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = [Common RectMakex:www * i y:0 w:www h:1.0 onSuperBounds:_baseView.bounds];
        if (i == [_titleAry count] - 1) {
            [btn1 setImage:[UIImage imageNamed:@"square_release.png"] forState:UIControlStateNormal];
            [btn1 setImageEdgeInsets:UIEdgeInsetsMake(btn1.frame.size.height / 4, btn1.frame.size.width / 3, btn1.frame.size.height / 4, btn1.frame.size.width / 3)];
        }
        else
        {
            [btn1 setTitle:[_titleAry objectAtIndex:i] forState:UIControlStateNormal];
            [btn1 setSelectedImageModel:E_Sanjiao];
        }
        [btn1 addTarget:self action:@selector(baseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setTag:i];
        [_baseView addSubview:btn1];
    }
}

- (void)loadSubView
{
    //_subView = [[UIView alloc] initWithFrame:[Common RectMakex:0 y:baseH w:1.0 h:subH onSuperBounds:self.bounds]];
    _subView = [[UIView alloc] initWithFrame:[Common RectMakex:0 y:TopH + SubH w:1.0 h:SubH onSuperBounds:self.bounds]];
    _subView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_subView];
    
    //square
    _subView1 = [[UIView alloc] initWithFrame:[Common RectMakex:0 y:0.0 w:1.0 h:1.0 onSuperBounds:_subView.bounds]];
    //_subView1.backgroundColor = [UIColor grayColor];
    [_subView addSubview:_subView1];
    _subView1.tag = E_square;
    
    //local title
    _loaclLb = [[UILabel alloc] init];
    _loaclLb.frame = [Common RectMakex:0 y:0 w:0.25 h:1.0 onSuperBounds:_subView1.bounds];
    _loaclLb.text = @"我的位置";
    _loaclLb.textColor = [UIColor blackColor];
    _loaclLb.textAlignment = NSTextAlignmentCenter;
    [_subView1 addSubview:_loaclLb];
    //
    _scrollv = [[UIScrollView alloc] init];
    _scrollv.frame = [Common RectMakex:0.25 y:0 w:0.75 h:1.0 onSuperBounds:_subView1.bounds];
    _scrollv.contentSize = CGSizeMake(_subView1.bounds.size.width * 1.1, _subView1.bounds.size.height);
    _scrollv.showsHorizontalScrollIndicator = NO;
    [_subView1 addSubview:_scrollv];
    
    NSArray *subView1titleAry = @[@"精华", @"全部", @"活动", @"吐槽"];
    float w1 = _scrollv.contentSize.width / [subView1titleAry count];
    for (int i = 0; i < [subView1titleAry count]; i++) {
        MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(w1 * i, 0, w1, _scrollv.contentSize.height);
        [btn setTitle:[subView1titleAry objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setSelectedImageModel:E_Changtiao];
        [btn addTarget:self action:@selector(sub1BtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i];
        [_scrollv addSubview:btn];
    }
    
    //group
    _subView2 = [[UIView alloc] initWithFrame:[Common RectMakex:0 y:0.0 w:1.0 h:1.0 onSuperBounds:_subView.bounds]];
    //_subView2.backgroundColor = [UIColor grayColor];
    [_subView addSubview:_subView2];
    _subView2.tag = E_group;

    NSArray *subView2titleAry = @[@"我的", @"附近"];
    float w2 = 1.0 / [subView2titleAry count];
    for (int i = 0; i < [subView2titleAry count]; i++) {
        MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
        btn.frame = [Common RectMakex:w2 * i y:0 w:w2 h:1.0 onSuperBounds:_subView2.bounds];
        [btn setTitle:[subView2titleAry objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setSelectedImageModel:E_Changtiao];
        [btn addTarget:self action:@selector(sub2BtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i];
        [_subView2 addSubview:btn];
    }
    
    //own
    _subView3 = [[UIView alloc] initWithFrame:[Common RectMakex:0 y:0.0 w:1.0 h:1.0 onSuperBounds:_subView.bounds]];
    //_subView3.backgroundColor = [UIColor grayColor];
    [_subView addSubview:_subView3];
    _subView3.tag = E_own;

    NSArray *subView3titleAry = @[@"密友", @"消息", @"名片"];
    float w3 = 1.0 / [subView3titleAry count];
    for (int i = 0; i < [subView3titleAry count]; i++) {
        MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
        btn.frame = [Common RectMakex:w3 * i y:0 w:w3 h:1.0 onSuperBounds:_subView3.bounds];
        [btn setTitle:[subView3titleAry objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setSelectedImageModel:E_Changtiao];
        [btn addTarget:self action:@selector(sub3BtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i];
        [_subView3 addSubview:btn];
    }
    
}

- (void)setLocalTitle:(NSString *)loacl
{
    _loaclLb.text = loacl;
}

- (void)setDefaultShow
{
    _squareIndex = E_ShowView_Square_QuanBu;
    _groupIndex = E_ShowView_Group_WoDe;
    _ownIndex = E_ShowView_Own_MiYou;
    [self setDefaultSub1Show:_squareIndex];
    [self setDefaultSub2Show:_groupIndex];
    [self setDefaultSub3Show:_ownIndex];
    
    [self setDefaultBaseShow:E_square];
}

- (void)setDefaultBaseShow:(int)DefautBaseTag
{
    MyButton *defautBtn = nil;
    for (MyButton *btn in _baseView.subviews) {
        if ([btn isKindOfClass:[MyButton class]]) {
            if (btn.tag == DefautBaseTag) {
                defautBtn = btn;
            }
        }
    }
    if (defautBtn) {
        [self baseBtnAction:defautBtn];
    }
    else
    {
        NSLog(@"defautBtn nil");
    }
}

- (void)setDefaultSub1Show:(int)curSelectTag
{
    MyButton *defautBtn = nil;
    for (MyButton *btn in _scrollv.subviews) {
        if ([btn isKindOfClass:[MyButton class]]) {
            if (btn.tag == curSelectTag) {
                defautBtn = btn;
            }
        }
    }
    [self sub1BtnAction:defautBtn];
}

- (void)setDefaultSub2Show:(int)curSelectTag
{
    MyButton *defautBtn = nil;
    for (MyButton *btn in _subView2.subviews) {
        if ([btn isKindOfClass:[MyButton class]]) {
            if (btn.tag == curSelectTag) {
                defautBtn = btn;
            }
        }
    }
    [self sub2BtnAction:defautBtn];
}

- (void)setDefaultSub3Show:(int)curSelectTag
{
    MyButton *defautBtn = nil;
    for (MyButton *btn in _subView3.subviews) {
        if ([btn isKindOfClass:[MyButton class]]) {
            if (btn.tag == curSelectTag) {
                defautBtn = btn;
            }
        }
    }
    [self sub3BtnAction:defautBtn];
}

- (void)setSubViewShow:(int)tag
{
    switch (tag) {
        case E_square:
        {
            _subView1.hidden = NO;
            _subView2.hidden = YES;
            _subView3.hidden = YES;
            [self setDefaultSub1Show:_squareIndex];
        }
            break;
        case E_group:
        {
            _subView1.hidden = YES;
            _subView2.hidden = NO;
            _subView3.hidden = YES;
            [self setDefaultSub2Show:_groupIndex];
        }
            break;
        case E_own:
        {
            _subView1.hidden = YES;
            _subView2.hidden = YES;
            _subView3.hidden = NO;
            [self setDefaultSub3Show:_ownIndex];
        }
            break;
        default:
            break;
    }
}

#pragma mark btn action

- (void)baseBtnAction:(MyButton *)sender
{
    NSLog(@"btn sender.tag==%d", sender.tag);
    if (sender.tag == [_titleAry count] - 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(showChatView)]) {
            [self.delegate showChatView];
        }
    }
    else
    {
        for (MyButton *btn in _baseView.subviews) {
            if ([btn isKindOfClass:[MyButton class]]) {
                if (btn.tag == sender.tag) {
                    sender.selected = YES;
                }
                else
                {
                    btn.selected = NO;
                }
            }
        }
        [self setSubViewShow:sender.tag];
    }
}

- (void)sub1BtnAction:(MyButton *)sender
{
    for (MyButton *btn in _scrollv.subviews) {
        if ([btn isKindOfClass:[MyButton class]]) {
            if (btn == sender) {
                sender.selected = YES;
            }
            else
            {
                btn.selected = NO;
            }
        }
    }
    _squareIndex = sender.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(showSquareSelectViewByTag:)]) {
        [self.delegate showSquareSelectViewByTag:sender.tag];
    }
}

- (void)sub2BtnAction:(MyButton *)sender
{
    for (MyButton *btn in _subView2.subviews) {
        if ([btn isKindOfClass:[MyButton class]]) {
            if (btn == sender) {
                sender.selected = YES;
            }
            else
            {
                btn.selected = NO;
            }
        }
    }
    _groupIndex = sender.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(showGroupSelectViewByTag:)]) {
        [self.delegate showGroupSelectViewByTag:sender.tag];
    }
}

- (void)sub3BtnAction:(MyButton *)sender
{
    if (sender.tag == E_ShowView_Own_MingPian) {

    }
    else
    {
        for (MyButton *btn in _subView3.subviews) {
            if ([btn isKindOfClass:[MyButton class]]) {
                if (btn == sender) {
                    sender.selected = YES;
                }
                else
                {
                    btn.selected = NO;
                }
            }
        }
        _ownIndex = sender.tag;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(showOwnSelectViewByTag:)]) {
        [self.delegate showOwnSelectViewByTag:sender.tag];
    }
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
