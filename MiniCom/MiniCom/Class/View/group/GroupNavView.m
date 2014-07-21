//
//  GroupNavView.m
//  MiniCom
//
//  Created by wlp on 14-6-10.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "GroupNavView.h"
#import "UIImageView+WebCache.h"
#import "AccountData.h"

@implementation GroupNavView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [Common addImageName:@"card_background_normal.png" onView:self frame:self.bounds];
        
        [Common addImageName:@"back.png" onView:self frame:[Common RectMakex:0.05 y:0.3 w:0.06 h:0.6 onSuperBounds:self.bounds]];
        
        _nameLb = [[UILabel alloc] init];
        _nameLb.textColor = [UIColor whiteColor];
        _nameLb.backgroundColor = [UIColor clearColor];
        [self addSubview:_nameLb];
        
        _countLb = [[UILabel alloc] init];
        _countLb.textColor = [UIColor whiteColor];
        _countLb.backgroundColor = [UIColor clearColor];
        [self addSubview:_countLb];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.bounds;
        [btn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self  addSubview:btn];
        
        //
        _memberIconView = [[UIScrollView alloc] init];
        [self addSubview:_memberIconView];
        _memberIconView.showsHorizontalScrollIndicator = NO;
        
        UIButton *memberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        memberBtn.frame = [Common RectMakex:0.5 y:0.25 w:0.5 h:0.70 onSuperBounds:self.bounds];
        [memberBtn addTarget:self action:@selector(memberBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self  addSubview:memberBtn];
    }
    return self;
}

- (void)updateWithMember:(NSString *)name Ary:(NSArray *)ary
{
    NSString *title = name;
    if ([self.chatType isEqualToString:SendType_Point]) {
        _memberIconView.frame = [Common RectMakex:0.85 y:0.25 w:0.15 h:0.70 onSuperBounds:self.bounds];
        _nameLb.frame = [Common RectMakex:0.15 y:0.2 w:0.65 h:0.8 onSuperBounds:self.bounds];
        _countLb.frame = CGRectZero;
    }
    else
    {
        _memberIconView.frame = [Common RectMakex:0.6 y:0.25 w:0.35 h:0.70 onSuperBounds:self.bounds];
        _nameLb.frame = [Common RectMakex:0.15 y:0.2 w:0.4 h:0.4 onSuperBounds:self.bounds];
        if (ary) {
            _countLb.frame = [Common RectMakex:0.15 y:0.6 w:0.4 h:0.4 onSuperBounds:self.bounds];
            _countLb.text = [NSString stringWithFormat:@"(%d人)", [ary count]];
        }
    }
    _nameLb.text = title;
    
    [self updateIconScrollView:ary];
}

- (void)updateIconScrollView:(NSArray *)ary
{
    for (UIView *view in [_memberIconView subviews]) {
        [view removeFromSuperview];
    }
    if (ary && [ary count] > 0) {
        int count = [ary count];
        float wh = _memberIconView.bounds.size.height * 0.8;
        float offset = (_memberIconView.bounds.size.height - wh) / 2;
        CGSize size = CGSizeMake(wh * count, wh);
        _memberIconView.contentSize = size;
        for (int i = 0; i < count; i++) {
            CGRect frame = CGRectMake((wh + offset) * i, offset, wh, wh);
            UIImageView *iconImageView = [Common initImageName:@"" onView:_memberIconView frame:frame];
            AccountData *acc = [ary objectAtIndex:i];
            //NSLog(@"acc.head==%@", acc.head);
            [iconImageView setImageWithURL:[Common getUrlWithImageName:acc.head] placeholderImage:[Common getDefaultAccountIcon]];
            iconImageView.layer.masksToBounds = YES;
            iconImageView.layer.cornerRadius = iconImageView.bounds.size.width / 2.0;
        }
    }
}

- (void)backBtnAction
{
    [self.delegate navBack];
}

- (void)memberBtnAction
{
    [self.delegate memberAction];
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
