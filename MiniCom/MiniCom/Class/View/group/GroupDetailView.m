//
//  GroupDetailView.m
//  MiniCom
//
//  Created by wlp on 14-6-11.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "GroupDetailView.h"
#import "UIButton+WebCache.h"
#import "Header.h"
#import "IconView.h"

@implementation GroupDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = self.bounds;
        [bgBtn addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
        [self  addSubview:bgBtn];
        
        UIView *useContentView = [[UIView alloc] initWithFrame:[Common RectMakex:0 y:0.15 w:1.0 h:0.3 onSuperBounds:self.bounds]];
        [self addSubview:useContentView];
        
        //bg
        [Common addImageName:@"card_background_normal.png"
                      onView:useContentView
                       frame:useContentView.bounds];
        
        float xoffset = 0.02;
        float yoffset = 0.01;
        
        UIView *contentView = [[UIView alloc] initWithFrame:[Common RectMakex:xoffset y:yoffset w:1.0 - xoffset * 2 h:1.0 - yoffset * 2 onSuperBounds:useContentView.bounds]];
        [useContentView addSubview:contentView];
    
        //
        float titleHeight = 40.0;
        float titleW = contentView.bounds.size.width /  2;
            
        //name
        _nameLb = [[UILabel alloc] init];
        _nameLb.frame = CGRectMake(0, 0, titleW, titleHeight);
        _nameLb.textColor = [UIColor whiteColor];
        _nameLb.backgroundColor = [UIColor clearColor];
        [contentView addSubview:_nameLb];
        
        //title
        UILabel *titleLb = [[UILabel alloc] init];
        titleLb.frame = CGRectMake(titleW, 0, titleW, titleHeight);
        titleLb.textColor = [UIColor whiteColor];
        titleLb.backgroundColor = [UIColor clearColor];
        titleLb.textAlignment = NSTextAlignmentRight;
        [contentView addSubview:titleLb];
        titleLb.text = @"群组设置";
        
        UIButton *memberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        memberBtn.frame = titleLb.frame;
        [memberBtn addTarget:self action:@selector(groupManager) forControlEvents:UIControlEventTouchUpInside];
        [contentView  addSubview:memberBtn];

        //line
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLb.frame.origin.y + titleLb.frame.size.height, contentView.bounds.size.width, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:lineView];

        //contentview
        float offset_y = 5;
        float content_y = lineView.frame.origin.y + lineView.frame.size.height + offset_y;
        _memberIconView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, content_y, contentView.bounds.size.width, contentView.bounds.size.height - content_y - offset_y)];
        [contentView addSubview:_memberIconView];
        //_memberIconView.backgroundColor = [UIColor lightGrayColor];
        //_memberIconView.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (void)updateWithMember:(NSString *)name Ary:(NSArray *)ary
{
    NSString *title = name;
    if (ary) {
        title = [NSString stringWithFormat:@"%@(%d人)", name, [ary count]];
    }
    _nameLb.text = title;
    
    self.memberAry = ary;
    
    [self updateScrollView:ary];
}

- (void)updateScrollView:(NSArray *)ary
{
    for (UIView *view in [_memberIconView subviews]) {
        [view removeFromSuperview];
    }
    if (ary && [ary count] > 0) {
        int count = [ary count];
        float hhh = 0.7;
        float wh = _memberIconView.bounds.size.height * hhh;
        CGSize size = CGSizeMake(wh * count, wh);
        _memberIconView.contentSize = size;
        
        for (int i = 0; i < count; i++) {
            
            AccountData *acc = [ary objectAtIndex:i];
            
            CGRect frame = CGRectMake(wh * i, 0, wh, wh);
            
            IconView *icon = [[IconView alloc] initWithFrame:frame image:acc.head title:acc.nickName];
            [icon addTarget:self action:@selector(memberBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            icon.tag = i;
            [_memberIconView addSubview:icon];
        }
    }
}

- (void)groupManager
{
    [self.delegate memberManagerAction];
    
    [self removeFromSuperview];
}

- (void)memberBtnAction:(id)sender
{
    IconView *btn = (IconView *)sender;
    AccountData *acc = [self.memberAry objectAtIndex:btn.tag];
    [self.delegate selectMember:acc];
    [self removeFromSuperview];
}


@end
