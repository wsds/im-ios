//
//  GroupSubView.m
//  MiniCom
//
//  Created by wlp on 14-6-28.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "GroupSubView.h"
#import "Common.h"
#import "GroupData.h"
#import "AccountData.h"
#import "UIImageView+WebCache.h"
#import "Header.h"

@implementation GroupSubView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIView *bgView = [[UIView alloc] initWithFrame:[Common RectMakex:0.025 y:0.025 w:0.9 h:0.9 onSuperBounds:self.bounds]];
        [self addSubview:bgView];
        
        UIImage *bgImage = [UIImage imageNamed:@"group_frame.png"];
        bgImage = [bgImage stretchableImageWithLeftCapWidth:5.0 topCapHeight:5.0];
        UIImageView *bg = [[UIImageView alloc] initWithFrame:bgView.bounds];
        bg.image = bgImage;
        [bgView addSubview:bg];
        
        _contentView = [[UIView alloc] initWithFrame:[Common RectMakex:0.025 y:0.025 w:0.9 h:0.9 onSuperBounds:bgView.bounds]];
        [bgView addSubview:_contentView];
        _contentView.clipsToBounds = YES;

        [self loadGroupInfoView];
        
        [self loadGroupAddView];
        
        _groupInfoView.hidden = YES;
        _groupAddView.hidden = YES;
        
        _viewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _viewBtn.frame = self.bounds;
        _viewBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:_viewBtn];
    }
    return self;
}

- (void)loadGroupInfoView
{
    _groupInfoView = [[UIView alloc] initWithFrame:_contentView.bounds];
    [_contentView addSubview:_groupInfoView];
    
    _nameLb = [[UILabel alloc] init];
    _nameLb.frame = [Common RectMakex:0 y:0 w:1.0 h:0.3 onSuperBounds:_groupInfoView.bounds];
    _nameLb.backgroundColor = [UIColor clearColor];
    _nameLb.textColor = [UIColor whiteColor];
    _nameLb.textAlignment = NSTextAlignmentCenter;
    [_groupInfoView addSubview:_nameLb];
    
    _countLb = [[UILabel alloc] init];
    _countLb.frame = [Common RectMakex:0 y:0.3 w:1.0 h:0.3 onSuperBounds:_groupInfoView.bounds];
    _countLb.backgroundColor = [UIColor clearColor];
    _countLb.textColor = [UIColor whiteColor];
    _countLb.textAlignment = NSTextAlignmentCenter;
    [_groupInfoView addSubview:_countLb];
    
    _membersView = [[UIView alloc] initWithFrame:[Common RectMakex:0.0 y:0.6 w:1.0 h:0.4 onSuperBounds:_groupInfoView.bounds]];
    [_groupInfoView addSubview:_membersView];
}

- (void)loadGroupAddView
{
    _groupAddView = [[UIView alloc] initWithFrame:_contentView.bounds];
    [_contentView addSubview:_groupAddView];
    
    UILabel *jiaLb = [[UILabel alloc] init];
    jiaLb.frame = [Common RectMakex:0.0 y:0.0 w:0.25 h:0.9 onSuperBounds:_groupAddView.bounds];
    jiaLb.backgroundColor = [UIColor clearColor];
    jiaLb.font = [UIFont boldSystemFontOfSize:[Common getCurFontSize:BaseFontSize_XXXL]];
    jiaLb.text = @"+";
    jiaLb.textColor = [UIColor whiteColor];
    jiaLb.textAlignment = NSTextAlignmentRight;
    [_groupAddView addSubview:jiaLb];
    
    _titleLb = [[UILabel alloc] init];
    _titleLb.frame = [Common RectMakex:0.25 y:0.3 w:0.75 h:0.4 onSuperBounds:_groupAddView.bounds];
    _titleLb.font = [UIFont systemFontOfSize:[Common getCurFontSize:BaseFontSize_M]];
    _titleLb.backgroundColor = [UIColor clearColor];
    _titleLb.textColor = [UIColor whiteColor];
    _titleLb.textAlignment = NSTextAlignmentLeft;
    [_groupAddView addSubview:_titleLb];
}

- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    _viewBtn.tag = tag;
}

- (void)setType:(ENUM_GROUP_TYPE)type
{
    _curType = type;
    
    switch (type) {
        case ENUM_GROUP_SHOW:
            _groupInfoView.hidden = NO;
            _groupAddView.hidden = YES;
            break;
        case ENUM_GROUP_ADD:
            _groupInfoView.hidden = YES;
            _groupAddView.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)setAddTitle:(NSString *)title
{
    _titleLb.text = title;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [_viewBtn addTarget:target action:action forControlEvents:controlEvents];
}

- (void)updateWithGroupData:(GroupData *)groupData
{
    _nameLb.text = groupData.name;
    if (groupData.members) {
        _countLb.text = [NSString stringWithFormat:@"(%d)", [groupData.members count]];
        [self updateWithMembers:groupData.members];
    }
}

- (void)updateWithMembers:(NSArray *)ary
{
    if (ary && [ary count] > 0) {
        int count = [ary count];
        float wh = _membersView.bounds.size.height * 0.8;
        float offset = (_membersView.bounds.size.height - wh) / 2;
        for (int i = 0; i < count; i++) {
            CGRect frame = CGRectMake((wh + offset) * i, offset, wh, wh);
            UIImageView *iconImageView = [Common initImageName:@"" onView:_membersView frame:frame];
            AccountData *acc = [ary objectAtIndex:i];
            //NSLog(@"acc.head==%@", acc.head);
            [iconImageView setImageWithURL:[Common getUrlWithImageName:acc.head] placeholderImage:[Common getDefaultAccountIcon]];
            iconImageView.layer.masksToBounds = YES;
            iconImageView.layer.cornerRadius = iconImageView.bounds.size.width / 2.0;
        }
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
